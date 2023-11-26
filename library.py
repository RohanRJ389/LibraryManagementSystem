import streamlit as st
import mysql.connector
import streamlit as st


# Connect to your MySQL database
db_connection = mysql.connector.connect(
    host='localhost',
    user='root',
    password='helloworld',
    database='lib'
)

# Create a Streamlit app with a navbar


def main():
    menu = ["Add New Book", "Lend Book", "Return Book", "Search Book",
            "Add New Publisher", "Add New Member", "Delete Book", "Lent Books", "All Staff"]
    choice = st.sidebar.selectbox("Menu", menu)

    if choice == "Add New Book":
        add_new_book()
    elif choice == "Lend Book":
        lend_book()
    elif choice == "Return Book":
        return_book()
    elif choice == "Search Book":
        search_book()
    elif choice == "Add New Publisher":
        add_new_publisher()
    elif choice == "Add New Member":
        add_new_member()
    elif choice == "Delete Book":
        delete_book()
    elif choice == "Lent Books":
        display_lent_books()
    elif choice == "All Staff":
        display_library_staff()

# Function to add a new book


def add_new_book():
    st.title("Add New Book to Library")

    # Input fields for book details
    book_ISBN = st.text_input("Enter ISBN:")
    book_Author = st.text_input("Enter Author:")
    book_Title = st.text_input("Enter Title:")
    book_Language = st.selectbox(
        "Select Language:", ["English", "Kannada", "Hindi"])
    book_Genre = st.text_input("Enter Genre:")

    try:
        # Fetch publishers and libraries from the database
        cursor = db_connection.cursor()

        # Fetch publishers
        cursor.execute("SELECT Publisher_ID, Name FROM publisher")
        publishers_data = cursor.fetchall()
        publishers_dict = {name: id for id, name in publishers_data}

        # Fetch libraries
        cursor.execute("SELECT Library_ID, Name FROM library")
        libraries_data = cursor.fetchall()
        libraries_dict = {name: id for id, name in libraries_data}

        # Dropdown for Publisher
        selected_publisher = st.selectbox(
            "Select Publisher:", list(publishers_dict.keys()))
        selected_publisher_id = publishers_dict.get(selected_publisher, None)

        # Dropdown for Library
        selected_library = st.selectbox(
            "Select Library:", list(libraries_dict.keys()))
        selected_library_id = libraries_dict.get(selected_library, None)

        number_of_copies = st.number_input(
            "Enter Number of Copies:", min_value=1)

        # Button to add the book
        if st.button("Add Book"):
            if selected_publisher_id is not None and selected_library_id is not None:
                # Call the stored procedure
                cursor.callproc('AddNewBook', (book_ISBN, book_Author, book_Title, book_Language,
                                               book_Genre, selected_publisher_id, selected_library_id,
                                               number_of_copies))
                # Commit changes to the database
                db_connection.commit()
                st.success("Book added successfully!")
            else:
                st.warning("Please select both Publisher and Library.")

    except mysql.connector.Error as e:
        st.error(f"Error: {e.msg}")

    finally:
        # Close the cursor and database connection
        cursor.close()


# Function to lend a book
def lend_book():
    st.title("Lend Book from Library")

    # Input fields for lending details
    book_ISBN = st.text_input("Enter ISBN of the book to lend:")
    member_ID = st.number_input("Enter Member ID:", min_value=1)

    # Button to lend the book
    if st.button("Lend Book"):
        try:
            # Create a cursor to execute SQL commands
            cursor = db_connection.cursor()

            # Call the stored procedure
            cursor.callproc('LendBook', (book_ISBN, member_ID))

            # Commit changes to the database
            db_connection.commit()

            st.success("Book lent successfully!")

        except mysql.connector.Error as e:
            st.error(f"Error: {e.msg}")

        finally:
            # Close the cursor and database connection
            cursor.close()

# Function to return a book


def return_book():
    st.title("Return Book to Library")

    # Input fields for returning details
    book_ISBN = st.text_input("Enter ISBN of the book to return:")
    member_ID = st.number_input("Enter Member ID:", min_value=1)
    return_date = st.date_input("Enter Return Date:")

    # Button to return the book
    if st.button("Return Book"):
        try:
            # Create a cursor to execute SQL commands
            cursor = db_connection.cursor()

            # Call the stored procedure
            cursor.callproc('ReturnBook', (book_ISBN, member_ID, return_date))

            # Commit changes to the database
            db_connection.commit()

            # Retrieve the fine amount
            cursor.execute(
                "SELECT Fine FROM borrow WHERE ISBN_Number = %s AND Member_ID = %s", (book_ISBN, member_ID))
            fine_amount = cursor.fetchone()[0]

            if fine_amount > 0:
                st.success(
                    f"Book returned successfully! Fine Amount: {fine_amount}")
            else:
                st.success("Book returned successfully!")

        except mysql.connector.Error as e:
            st.error(f"Error: {e.msg}")

        finally:
            # Close the cursor and database connection
            cursor.close()


def show_library_staff():
    try:
        # Create a cursor to execute SQL commands
        cursor = db_connection.cursor()

        # Execute SQL query to fetch library staff members
        cursor.execute("SELECT * FROM staff")

        # Fetch all rows
        staff_members = cursor.fetchall()

        # Display staff members details
        if staff_members:
            st.header("Library Staff Members")
            for member in staff_members:
                st.write(f"ID: {member[0]}")
                st.write(f"Name: {member[1]}")
                st.write(f"Role: {member[2]}")
                st.write(f"Contact: {member[3]}")
                st.write("---")
        else:
            st.warning("No staff members found.")

    except mysql.connector.Error as e:
        st.error(f"Error: {e.msg}")

    finally:
        # Close the cursor and database connection
        cursor.close()


# Function to search book by ISBN, author, or title
def search_book():
    st.title("Search Book")

    search_type = st.selectbox("Search by:", ["ISBN", "Author", "Title"])

    search_query = st.text_input(f"Enter {search_type} of the book to search:")

    if st.button("🔍Search Book"):
        try:
            cursor = db_connection.cursor()

            if search_type == "ISBN":
                cursor.execute(
                    "SELECT * FROM book WHERE ISBN_Number = %s", (search_query,))
            elif search_type == "Author":
                cursor.execute(
                    "SELECT * FROM book WHERE Author LIKE %s", (f'%{search_query}%',))
            elif search_type == "Title":
                cursor.execute(
                    "SELECT * FROM book WHERE Book_Title LIKE %s", (f'%{search_query}%',))

            result = cursor.fetchall()

            if result:
                for row in result:
                    st.markdown(f"**{row[2]}**")
                    st.markdown(f"by **{row[1]}**")
                    st.markdown(f"*{row[0]}* : *{row[3]}*")

                    # Fetch publisher details
                    publisher_id = row[5]
                    cursor.execute(
                        "SELECT * FROM publisher WHERE Publisher_ID = %s", (publisher_id,))
                    publisher_info = cursor.fetchone()
                    if publisher_info:
                        publisher_name = publisher_info[1]
                        publisher_address = f"{publisher_info[2]}, {publisher_info[3]}, {publisher_info[4]}, {publisher_info[5]}"
                        st.write(f"{publisher_name}")
                        st.write(f"{publisher_address}")

                    # Fetch available copies
                    isbn = row[0]
                    cursor.execute(
                        "SELECT number_available FROM book_copies WHERE ISBN_Number = %s", (isbn,))
                    copies_info = cursor.fetchone()
                    if copies_info:
                        st.markdown(f"Available: **{copies_info[0]}**")

                    st.markdown("---")

            else:
                st.warning("No books found matching the search criteria.")

        except mysql.connector.Error as e:
            st.error(f"Error: {e.msg}")

        finally:
            cursor.close()


def delete_book():
    st.title("Delete Book from Library")

    # Input field for ISBN of the book to delete
    book_ISBN = st.text_input("Enter ISBN of the book to delete:")

    # Button to delete the book
    if st.button("Delete Book"):
        try:
            # Create a cursor to execute SQL commands
            cursor = db_connection.cursor()

            # Call the stored procedure to delete the book
            cursor.callproc('DeleteBook', (book_ISBN,))

            # Commit changes to the database
            db_connection.commit()

            st.success("Book deleted successfully!")

        except mysql.connector.Error as e:
            st.error(f"Error: {e.msg}")

        finally:
            # Close the cursor and database connection
            cursor.close()


def add_new_publisher():
    st.title("Add New Publisher")

    # Get the maximum Publisher_ID from the publisher table
    try:
        cursor = db_connection.cursor()
        cursor.execute("SELECT MAX(Publisher_ID) FROM publisher")
        max_publisher_id = cursor.fetchone()[0]
        new_publisher_id = max_publisher_id + 1 if max_publisher_id is not None else 1

        # Input fields for adding new publisher
        publisher_name = st.text_input("Enter Publisher Name:")
        publisher_block = st.text_input("Enter Publisher Block:")
        publisher_street = st.text_input("Enter Publisher Street:")
        publisher_city = st.text_input("Enter Publisher City:")
        publisher_pincode = st.text_input("Enter Publisher Pincode:")

        # Button to add the new publisher
        if st.button("Add Publisher"):
            try:
                # Call the stored procedure or execute SQL INSERT query to add new publisher
                cursor.execute("INSERT INTO publisher (Publisher_ID, Name, Block_No, Street, City, Pincode) "
                               "VALUES (%s, %s, %s, %s, %s, %s)",
                               (new_publisher_id, publisher_name, publisher_block, publisher_street,
                                publisher_city, publisher_pincode))
                db_connection.commit()

                st.success("New Publisher added successfully!")
            except mysql.connector.Error as e:
                st.error(f"Error: {e.msg}")
    except mysql.connector.Error as e:
        st.error(f"Error: {e.msg}")

    finally:
        # Close the cursor and database connection
        cursor.close()


def add_new_member():
    st.title("Add New Member")

    # Get the maximum Member_ID from the member table
    try:
        cursor = db_connection.cursor()
        cursor.execute("SELECT MAX(Member_ID) FROM member")
        max_member_id = cursor.fetchone()[0]
        new_member_id = max_member_id + 1 if max_member_id is not None else 1

        # Input fields for adding new member
        member_name = st.text_input("Enter Member Name:")
        member_email = st.text_input("Enter Member Email:")

        # Button to add the new member
        if st.button("Add Member"):
            try:
                # Call the stored procedure or execute SQL INSERT query to add new member
                cursor.execute("INSERT INTO member (Member_ID, Name, Email) VALUES (%s, %s, %s)",
                               (new_member_id, member_name, member_email))
                db_connection.commit()

                st.success("New Member added successfully!")
            except mysql.connector.Error as e:
                st.error(f"Error: {e.msg}")
    except mysql.connector.Error as e:
        st.error(f"Error: {e.msg}")

    finally:
        # Close the cursor and database connection
        cursor.close()

# Function to display lent books


def display_lent_books():
    try:
        # Create a cursor to execute SQL commands
        cursor = db_connection.cursor()

        # Execute SQL query to fetch lent books
        cursor.execute("""
            SELECT b.ISBN_Number, b.Author, b.Book_Title, m.Name AS Member_Name, br.Due_Date
            FROM borrow AS br
            INNER JOIN book AS b ON br.ISBN_Number = b.ISBN_Number
            INNER JOIN member AS m ON br.Member_ID = m.Member_ID
            WHERE br.Return_Date IS NULL
        """)

        # Fetch all rows
        lent_books = cursor.fetchall()

        # Display lent books
        if lent_books:
            st.header("Lent Books (Yet to be returned)")
            for book in lent_books:
                st.write(f"ISBN: {book[0]}")
                st.write(f"Author: {book[1]}")
                st.write(f"Title: {book[2]}")
                st.write(f"Borrowed by: {book[3]}")
                st.write(f"Due Date: {book[4]}")
                st.write("---")
        else:
            st.warning("No books are currently lent and yet to be returned.")

    except mysql.connector.Error as e:
        st.error(f"Error: {e.msg}")

    finally:
        # Close the cursor and database connection
        cursor.close()


# Function to display library staff details
def display_library_staff():
    try:
        # Create a cursor to execute SQL commands
        cursor = db_connection.cursor()

        # Execute SQL query to fetch library staff details
        cursor.execute("SELECT * FROM staff")

        # Fetch all rows
        staff_members = cursor.fetchall()

        # Display library staff details
        if staff_members:
            st.header("Library Staff Members")
            for staff_member in staff_members:
                st.write(f"ID: {staff_member[0]}")
                st.write(f"Name: {staff_member[1]}")
                st.write(f"Role: {staff_member[2]}")
                st.write(f"Contact: {staff_member[3]}")
                st.write("---")
        else:
            st.warning("No library staff members found.")

    except mysql.connector.Error as e:
        st.error(f"Error: {e.msg}")

    finally:
        # Close the cursor and database connection
        cursor.close()


# Run the Streamlit app
if __name__ == "__main__":
    main()
