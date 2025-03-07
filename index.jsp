<%@ page import="java.sql.*" %>
<html>
<head>
    <title>Feedback App</title>
    	<link rel="stylesheet" href="mystyle.css">
       		<script>
        		function check() {
            			let name = document.getElementById("name");
            			let feedback = document.getElementById("feedback");
            			let rating = document.querySelector('input[name="f"]').value;

            			if (name.value == "") {
                			alert("You did not enter a name");
                			name.focus();
                			return false;
            			} else if (name.value.trim() == "") {
                			alert("Name cannot be blank");
                			name.value = "";
                			name.focus();
                			return false;
            			} else if (!name.value.match(/^[A-Za-z]+$/)) {
                			alert("Name should contain only alphabets");
                			name.value = "";
                			name.focus();
                			return false;
            			} else if (feedback.value.trim().length < 10) {
                			alert("Feedback must be at least 10 characters long");
                			feedback.focus();
                			return false;
            			} else {
                			return true;
            			}
        		}

        		function setRating(rating) {
            			document.querySelectorAll('.star').forEach((star, index) => {
                		star.classList.toggle('checked', index < rating);
            		});
            			document.getElementById('rating-value').value = rating;
        		}
				document.addEventListener('DOMContentLoaded', (event) => {
           	 		setRating(5); // Set default rating to 5 stars
        		});
    		</script>
</head>
<body>
    <center>
        <h1>Feedback App</h1>
        <form onsubmit="return check()" method="post">
            <input type="text" name="name" placeholder="Enter your name " id="name" />
            <br><br>
            <label for="rating">Rate our service:</label>
            <div class="stars">
                <span class="star" onclick="setRating(1)">&#9733;</span>
                <span class="star" onclick="setRating(2)">&#9733;</span>
                <span class="star" onclick="setRating(3)">&#9733;</span>
                <span class="star" onclick="setRating(4)">&#9733;</span>
                <span class="star" onclick="setRating(5)">&#9733;</span>
            </div>
            <input type="hidden" name="f" id="rating-value" value="5"/>
            <br><br>
            <textarea name="feedback" placeholder="Enter your feedback" rows="4" cols="30" id="feedback" ></textarea>
            <br><br>
            <input type="submit" name="btn" value="Submit" class="btn"/>
        </form>

        <%
            if ((request.getParameter("btn") != null) && (!request.getParameter("name").equals(""))) {
                Connection con = null;
                PreparedStatement pst = null;
                try {
                    DriverManager.registerDriver(new com.mysql.cj.jdbc.Driver());
                    String url = "jdbc:mysql://localhost:3306/feedbackapp";
                    con = DriverManager.getConnection(url, "root", "abc456");
                    String sql = "insert into feedback (name, rating, feedback) values (?, ?, ?)";
                    pst = con.prepareStatement(sql);
                    pst.setString(1, request.getParameter("name"));
                    String rating = request.getParameter("f");
                    pst.setString(2, rating);
                    pst.setString(3, request.getParameter("feedback"));
                    pst.executeUpdate();
                    String msg = "Thank You For Your Feedback";
        %>
                    <h2 id="msg"><%= msg %></h2>
        <%
                } catch (SQLException e) {
                    out.println("Issue: " + e);
                } finally {
                    if (pst != null) {
                        try {
                            pst.close();
                        } catch (SQLException e) {
                            e.printStackTrace();
                        }
                    }
                    if (con != null) {
                        try {
                            con.close();
                        } catch (SQLException e) {
                            e.printStackTrace();
                        }
                    }
                }
            }
        %>
    </center>
</body>
</html>
