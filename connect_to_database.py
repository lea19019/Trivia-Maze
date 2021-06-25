from mysql.connector import connect

# passing username and pass arguments are optional, category argument is not.
def connect_to_database(question_category, username_string = '', password_string = ''):
	query = "SELECT q.question_text, a.answers_text, a.answers_true FROM questions q INNER JOIN common_lookup cl ON q.common_lookup_id = cl.common_lookup_id INNER JOIN answers a ON q.question_id = a.questions_question_id WHERE cl.common_lookup_question_categories = '" + question_category + "'"
	if username_string == '':
		username_string = input("Please enter your username: ")
	if password_string == '':
		password_string = input("Please enter your password: ")
	try:
		with connect(
			host = "localhost",
			user = username_string,
			password = password_string,
			database = "gamedb",
			) as connection:
				with connection.cursor() as cursor:
					cursor.execute(query)
					result = cursor.fetchall()
					# returns a list of lists that contains the result.
					return result
	except Exception as e:
		print (e)

# example call to function. username and pass provided as an example.
print(connect_to_database('math', 'test_account', 'test'))