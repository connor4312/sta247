import java.lang.System;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.sql.*;
import java.util.Collections;

public class Assignment2 {

	/* A connection to the database */
	private Connection connection;

	private final String songwritersQuery = "SELECT a2.name\n" +
			"FROM Artist a1, Album, BelongsToAlbum, Song, Artist a2\n" +
			"WHERE a1.name = ?\n" +
			"AND Album.artist_id = a1.artist_id\n" +
			"AND BelongsToAlbum.album_id = Album.album_id\n" +
			"AND Song.song_id = BelongsToAlbum.song_id\n" +
			"AND a2.artist_id = Song.songwriter_id\n" +
			"AND a1.artist_id != a2.artist_id";

	private final String collaboratorsQuery = "SELECT a2.name\n" +
			"FROM Artist a1, Collaboration, Artist a2\n" +
			"WHERE a1.name = ?\n" +
			"AND (\n" +
			"(artist1 = a1.artist_id AND artist2 = a2.artist_id)\n" +
			"OR (artist2 = a1.artist_id AND artist1 = a2.artist_id)\n" +
			")";

	/**
	 * Empty constructor. There is no need to modify this.
	 */
	public Assignment2() {
		try {
			Class.forName("org.postgresql.Driver");
		} catch (ClassNotFoundException e) {
			System.err.println("Failed to find the JDBC driver");
		}
	}

	/**
	* Establishes a connection to be used for this session, assigning it to
	* the instance variable 'connection'.
	*
	* @param  url       the url to the database
	* @param  username  the username to connect to the database
	* @param  password  the password to connect to the database
	* @return           true if the connection is successful, false otherwise
	*/
	public boolean connectDB(String url, String username, String password) {
		try {
			this.connection = DriverManager.getConnection(url, username, password);
			return true;
		} catch (SQLException se) {
			System.err.println("SQL Exception. <Message>: " + se.getMessage());
			return false;
		}
	}

	/**
	* Closes the database connection.
	*
	* @return true if the closing was successful, false otherwise
	*/
	public boolean disconnectDB() {
		try {
			this.connection.close();
		return true;
		} catch (SQLException se) {
			System.err.println("SQL Exception. <Message>: " + se.getMessage());
			return false;
		}
	}

	protected ArrayList<String> resultsToList(ResultSet results) throws SQLException {
		ArrayList list = new ArrayList<String>();
		while (results.next()) {
			list.add(results.getString(1));
		}
		results.close();

		return list;
	}

	protected void setSearchPath() throws SQLException {
		connection.prepareStatement("set search_path to artistdb;").execute();
	}

	protected ArrayList<String> run(String query, String ...params) {
		try {
			setSearchPath();
			PreparedStatement stmt = connection.prepareStatement(query);
			for (int i = 0; i < params.length; i++) {
				stmt.setString(i + 1, params[i]);
			}

			return resultsToList(stmt.executeQuery());
		} catch (SQLException e) {
			e.printStackTrace();
		}

		return new ArrayList<>();
	}

	/**
	 * Returns a sorted list of the names of all musicians and bands
	 * who released at least one album in a given genre.
	 *
	 * Returns an empty list if no such genre exists or no artist matches.
	 *
	 * NOTE:
	 *    Use Collections.sort() to sort the names in ascending
	 *    alphabetical order.
	 *
	 * @param genre  the genre to find artists for
	 * @return       a sorted list of artist names
	 */
	public ArrayList<String> findArtistsInGenre(String genre) {
		ArrayList results = run("SELECT Artist.name\n" +
			"FROM Artist, Album, Genre\n" +
			"WHERE Artist.artist_id = Album.artist_id\n" +
			"AND Album.genre_id = Genre.genre_id\n" +
			"AND Genre.genre = ?;", genre);

		Collections.sort(results);
		return results;
	}

	/**
	 * Returns a sorted list of the names of all collaborators
	 * (either as a main artist or guest) for a given artist.
	 *
	 * Returns an empty list if no such artist exists or the artist
	 * has no collaborators.
	 *
	 * NOTE:
	 *    Use Collections.sort() to sort the names in ascending
	 *    alphabetical order.
	 *
	 * @param artist  the name of the artist to find collaborators for
	 * @return        a sorted list of artist names
	 */
	public ArrayList<String> findCollaborators(String artist) {
		ArrayList results = run(collaboratorsQuery, artist);

		Collections.sort(results);
		return results;
	}


	/**
	 * Returns a sorted list of the names of all songwriters
	 * who wrote songs for a given artist (the given artist is excluded).
	 *
	 * Returns an empty list if no such artist exists or the artist
	 * has no other songwriters other than themself.
	 *
	 * NOTE:
	 *    Use Collections.sort() to sort the names in ascending
	 *    alphabetical order.
	 *
	 * @param artist  the name of the artist to find the songwriters for
	 * @return        a sorted list of songwriter names
	 */
	public ArrayList<String> findSongwriters(String artist) {
		ArrayList results = run(songwritersQuery, artist);
		Collections.sort(results);
		return results;
	}

	/**
	 * Returns a sorted list of the names of all acquaintances
	 * for a given pair of artists.
	 *
	 * Returns an empty list if either of the artists does not exist,
	 * or they have no acquaintances.
	 *
	 * NOTE:
	 *    Use Collections.sort() to sort the names in ascending
	 *    alphabetical order.
	 *
	 * @param artist1  the name of the first artist to find acquaintances for
	 * @param artist2  the name of the second artist to find acquaintances for
	 * @return         a sorted list of artist names
	 */
	public ArrayList<String> findAcquaintances(String artist1, String artist2) {
		ArrayList results = run(
				"((" + songwritersQuery + ") INTERSECT (" + songwritersQuery + "))\n" +
				"UNION\n" +
				"((" + collaboratorsQuery + ") INTERSECT (" + collaboratorsQuery + "))",
				artist1, artist2, artist1, artist2);

		Collections.sort(results);
		return results;
	}


	public static void main(String[] args) {

		Assignment2 a2 = new Assignment2();

		/* TODO: Change the database name and username to your own here. */
		a2.connectDB("jdbc:postgresql://localhost:5432/connor",
		             "connor",
		             "");

                System.err.println("\n----- ArtistsInGenre -----");
                ArrayList<String> res = a2.findArtistsInGenre("Rock");
                for (String s : res) {
                  System.err.println(s);
                }

		System.err.println("\n----- Collaborators -----");
		res = a2.findCollaborators("Michael Jackson");
		for (String s : res) {
		  System.err.println(s);
		}

		System.err.println("\n----- Songwriters -----");
	        res = a2.findSongwriters("Justin Bieber");
		for (String s : res) {
		  System.err.println(s);
		}

		System.err.println("\n----- Acquaintances -----");
		res = a2.findAcquaintances("Jaden Smith", "Miley Cyrus");
		for (String s : res) {
		  System.err.println(s);
		}


		a2.disconnectDB();
	}
}

