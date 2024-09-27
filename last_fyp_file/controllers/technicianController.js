const db = require("../utils/database");
const bcrypt = require('bcryptjs');

function createTechnician(req, res) {
  const { type } = req.user;

  // Check if the user is an admin
  if (type !== "admin") {
    return res.status(401).json({ message: "Unauthorized" });
  }

  const { email, name, password, specialization, phone_number, location } = req.body;

  // Check if technician already exists
  const isTechnicianExist = `SELECT * FROM technician WHERE email="${email}"`;

  db.query(isTechnicianExist, async (error, rows) => {
    if (error) {
      return res.status(500).json({ status: 500, message: "Internal Server Error" });
    }

    // If the technician already exists
    if (rows.length > 0) {
      return res.status(400).json({ message: "Email already exists", status: 400 });
    }

    try {
      // Hash the password using bcryptjs
      const hashedPassword = await bcrypt.hash(password, 10); // Salt rounds = 10

      // Insert the new technician into the database with the hashed password
      const createTechnicianQuery = `INSERT INTO technician (email, name, password, specialization, status, phone_number, location)
            VALUES ('${email}', '${name}', '${hashedPassword}', '${specialization}', 'free', '${phone_number}', '${location}')`;

      db.query(createTechnicianQuery, (error, rows) => {
        if (error) {
          return res.status(500).json({ status: 500, message: "Internal Server Error" });
        }

        return res.status(201).json({
          message: "Technician created successfully",
          result: rows[0],
          status: 201,
        });
      });

    } catch (err) {
      console.error("Error hashing the password:", err);
      return res.status(500).json({ status: 500, message: "Internal Server Error" });
    }
  });
}


function getAllTechnicians(req, res) {
  const { type } = req.user;
  const { status } = req.query;

  if (type !== "admin") {
    return res.status(401).json({ message: "Unauthorized", status: 401 });
  }
  let dbQuery = `SELECT * FROM technician`;
  if (status === "free") {
    dbQuery += ` WHERE ongoing_order_id IS NULL`;
  }

  console.log('Generated Query: ', dbQuery);
  db.query(dbQuery, (error, rows) => {
    if (error) {
      console.error('Error executing query:', error);
      return res.status(500).json({ message: "Error fetching technicians", status: 500 });
    }
    return res.status(200).json({ result: rows, status: 200 });
  });

}

function getTechnicianById(req, res) {
  const { type } = req.user;
  const technicianId = req.params.id;

  if (type !== "admin") {
    return res.status(401).json({ message: "Unauthorized", status: 401 });
  }
  const query = `SELECT * FROM technician WHERE technician_id = ${technicianId}`;
  db.query(query, (error, technician) => {
    if (error) {
      console.error(error);
      return res
        .status(500)
        .json({ message: "Error fetching technician", status: 500 });
    }

    return res.status(200).json({ technician: technician, status: 200 });
  });
}

function updateTechnician(req, res) {
  const { type } = req.user;
  const technicianId = req.params.id;
  const { name, specialization, phone_number, email, location } = req.body;

  if (type !== "admin") {
    return res.status(401).json({ message: "Unauthorized", status: 401 });
  }

  const updateQuery = `UPDATE technician SET location = '${location}' , name ='${name}' , email = '${email}' , specialization = '${specialization}', phone_number = '${phone_number}' WHERE technician_id = ${technicianId}`;
  db.query(updateQuery, (error, result) => {
    if (error) {
      console.error(error);
      return res.status(500).json({ message: "Error updating technician" });
    }

    if (result.affectedRows === 0) {
      return res.status(404).json({ message: "Technician not found" });
    }

    return res
      .status(200)
      .json({ message: "Technician updated successfully", status: 200 });
  });
}

function deleteTechnician(req, res) {
  const { type } = req.user;
  const technicianId = req.params.id;

  if (type !== "admin") {
    return res.status(401).json({ message: "Unauthorized", status: 401 });
  }

  const deleteQuery = `DELETE FROM technician WHERE technician_id = ${technicianId}`;
  db.query(deleteQuery, (error, result) => {
    if (error) {
      console.error(error);
      return res.status(500).json({ message: "Error deleting technician" });
    }

    if (result.affectedRows === 0) {
      return res.status(404).json({ message: "Technician not found" });
    }

    return res
      .status(200)
      .json({ message: "Technician deleted successfully", status: 200 });
  });
}

function getTechnicianByToken(req, res) {
  const token = req.headers.authorization.split(" ")[1]; // Extract token from authorization header

  if (!token) {
    return res.status(401).json({ message: "Unauthorized", status: 401 });
  }

  const getTechnicianQuery = `SELECT * FROM technician WHERE token = '${token}'`;
  db.query(getTechnicianQuery, (error, technician) => {
    if (error) {
      throw error;
    }

    if (technician.length === 0) {
      return res
        .status(404)
        .json({ message: "Technician not found", status: 404 });
    }

    return res.status(200).json({ status: 200, data: technician[0] });
  });
}

function viewTechOrdersDetail(req, res) {
  const technicianId = req.params.id; // Assuming you're passing technician ID in the request parameters

  const dbQuery = `
    SELECT 
      ordertable.*,
      c.name AS customer_name,
      c.location AS customer_address,
      c.phone_number AS customer_phone_number,
      c.email AS customer_email,
      c.auto_gate_brand AS customer_auto_gate_brand,
      c.alarm_brand AS customer_alarm_brand,
      c.warranty AS customer_warranty
    FROM 
      ordertable
    JOIN 
      customer c ON ordertable.customer_id = c.customer_id
    WHERE 
      ordertable.technician_id = ${technicianId}  -- Retrieve by technician ID
  `;

  db.query(dbQuery, (error, results) => {
    if (error) {
      console.error("Error executing database query:", error);
      res.status(500).json({ error: "Internal Server Error" });
      return;
    }

    if (results.length === 0) {
      return res.status(404).json({ error: "No orders found for this technician", status: 404 });
    }

    // Map the results if there are multiple orders
    const orders = results.map((order) => ({
      orderId: order.order_id,
      orderDate: order.order_date,
      orderDoneDate: order.order_done_date,
      orderStatus: order.order_status,
      orderImage: order.order_img,
      orderDoneImage: order.order_done_img,
      orderDetail: order.order_detail,
      priority: order.urgency_level,
      locationDetail: order.location_detail,
      priceStatus: order.price_status,
      totalPrice: order.total_price,
      ProblemType: order.problem_type,
      customer: {
        name: order.customer_name,
        address: order.customer_address,
        email: order.customer_email,
        phone: order.customer_phone_number,
        autogateBrand: order.customer_auto_gate_brand,
        alarmBrand: order.customer_alarm_brand,
        warranty: order.customer_warranty,
      },
    }));

    return res.status(200).json({ status: 200, result: orders });
  });
}


module.exports = {
  createTechnician,
  getAllTechnicians,
  getTechnicianById,
  updateTechnician,
  deleteTechnician,
  getTechnicianByToken,
  viewTechOrdersDetail,
};
