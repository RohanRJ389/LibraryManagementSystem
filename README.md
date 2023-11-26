# Library Management System

This project is a Library Management System implemented in Python using Streamlit for the user interface and MySQL for the database.

## Introduction

The project contains two main files:

### `lib.sql`

The SQL script that sets up the MySQL database structure, tables, triggers, and sample data for the library management system.

### `library.py`

The Python script utilizing Streamlit to create a user interface for interacting with the library database. It includes functions for various actions such as adding new books, lending books, returning books, searching books, managing publishers and members, and displaying staff information.

## Getting Started

To run this project locally:

1. Clone this repository:

`git clone https://github.com/RohanRJ389/LibraryManagementSystem.git`

2. Set up your MySQL database using the `lib.sql` script provided in the repository.

3. Install the required Python packages:

`pip install -r requirements.txt`

4. Ensure you have MySQL installed and running on your local machine. Modify the database connection details in `library.py` as needed.

5. Run the Streamlit app:

`streamlit run library.py`

## Usage

The Streamlit app provides a user-friendly interface to perform various library management tasks:

- Adding new books
- Lending books to members
- Returning books
- Searching for books by ISBN, author, or title
- Managing publishers and members
- Displaying lent books and staff information

## Screenshots

![image](https://github.com/RohanRJ389/LibraryManagementSystem/assets/128975431/5b6c4033-2f0f-4fe8-bc09-5f3d99d6c9ea)

## Contributing

Contributions are welcome! If you have any suggestions, feature requests, or found any issues, feel free to open an issue or create a pull request.






