import React from "react";
import { Link } from "react-router-dom";
import BreadCrumb from "../components/BreadCrumb";
import Meta from "../components/Meta";
import Container from "../components/Container";
import CustomInput from "../components/CustomInput";
import { useState, useEffect } from "react";
import axios from "axios";
import { loginRoute } from "../api/APIRoutes";
import { ToastContainer, toast } from "react-toastify";
import "react-toastify/dist/ReactToastify.css";
const Login = () => {
  const [done, setDone] = useState({status: false, msg: "empty form"});
  const [values, setValues] = useState({
    email :"",
    password: "",
  });

  // form validation after each modification
  useEffect(() => {
    const { email, password } = values;
    if (email === "") {
      setDone({ status: false, msg: "Please enter your email" });
    } else if (password === "") {
      setDone({ status: false, msg: "Please enter your password" });
    } else {
      setDone({ status: true, msg: "validated form" });
    }
  }, [values]);

  const handleSubmit = async (event) => {
    event.preventDefault();
    if (handleValidation()) {
      console.log("in validation", loginRoute);
      const { password, email } = values;
      const res = await axios.post(loginRoute, {
        email: email,
        password: password
      })
      console.log(res);
      if (res.status === 205) {
        alert("Invalid Credentials");
        toast.success("Invalid Credentials", toastOptions);
      } else {
        localStorage.setItem("user", JSON.stringify(res.data));
        toast.success("Đăng nhập thành công", toastOptions);
        window.location.assign('./');
      }
      console.log("OK");
    }
  };
  const handleChange = (event) => {
    setValues({
      ...values,
      [event.target.name]: event.target.value,
    });
  };
  const handleValidation = () => {
    if (done["status"] === false) {
      toast.error(done["msg"], toastOptions);
      return false;
    }
    return true;
  };

  return (
    
    
       <>
      <Meta title={"Login"} />
      <BreadCrumb title="Login" />

      <Container class1="login-wrapper py-5 home-wrapper-2">
        <div className="row">
          <div className="col-12">
            <div className="auth-card">
              <h3 className="text-center mb-3">Login</h3>
              <form action="" 
                    className="d-flex flex-column gap-15"
                    onSubmit={(event) => handleSubmit(event)}
                    data-model-toggle="defaultModal"
                    noValidate
              >
                <input type="email" 
                      name="email" 
                      placeholder="Email"
                      onChange={(e) => handleChange(e)}
                      required
                      />
                <input
                  type="password"
                  name="password"
                  placeholder="Password"
                  onChange={(e) => handleChange(e)}
                required
                />
                <div>
                  <Link to="/forgot-password">Forgot Password?</Link>


                  <div className="mt-3 d-flex justify-content-center gap-15 align-items-center">
                    <button className="button border-0" 
                            type="submit" 
                            onClick={handleValidation}
                    >
                      Login
                    
                    
                    
                    </button>
                    <Link to="/signup" className="button signup">
                      SignUp
                    </Link>
                  </div>
                </div>
              </form>
            </div>
          </div>
        </div>
      </Container>
    </>
   
    
    
  );
};

export default Login;

const toastOptions = {
  position: "top-right",
  autoClose: 3000,
  pauseOnHover: true,
  draggable: true,
  theme: "dark",
};