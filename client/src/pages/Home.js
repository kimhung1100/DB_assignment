import React, { useEffect, useState } from "react";
import axios from "axios";
import { Link, useParams, useNavigate } from "react-router-dom";
import ReactStars from "react-rating-stars-component";
import Marquee from "react-fast-marquee";
import BlogCard from "../components/BlogCard";
import { useSelector, useDispatch } from "react-redux";
// import ProductCard from "../components/ProductCard";
import SpecialProduct from "../components/SpecialProduct";
import Container from "../components/Container";
// import { services } from "../utils/Data";
import watch from "../images/watch.jpg";
import watch2 from "../images/watch-1.avif";

const BackendPORT = 5000;
const Home = () => {
  let { id } = useParams();
  const [products, setProducts] = useState([]);
  const navigate = useNavigate();
  const initialValues = {
    productName: "",
    categoryName: "",
  };
  useEffect(() => {
    axios.get(`http://localhost:${BackendPORT}/books/`).then((response) => {
      console.log(response.data);
      setProducts(response.data);
      console.log(products);
    });
  }, [id]);
  useEffect(() => {
    console.log("printing products");
    console.log(products);
    // console.log(products[0])
  }, [products]);
  const handleProductClick = (productId) => {
    navigate(`/product/${productId}`);
  };
  return (
    <>
      {/* first container (5 picture) */}
      <Container class1="home-wrapper-1 py-5">
        <div className="row">
          <div className="col-6">
            <div className="main-banner position-relative ">
              <img
                src="images/main-banner-1.jpg"
                className="img-fluid rounded-3"
                alt="main banner"
              />
              <div className="main-banner-content position-absolute">
                <h4>SUPERCHARGED FOR PROS.</h4>
                <h5>iPad S13+ Pro.</h5>
                <p>From $999.00 or $41.62/mo.</p>
                <Link className="button">BUY NOW</Link>
              </div>
            </div>
          </div>
          <div className="col-6">
            <div className="d-flex flex-wrap gap-10 justify-content-between align-items-center">
              <div className="small-banner position-relative">
                <img
                  src="images/catbanner-01.jpg"
                  className="img-fluid rounded-3"
                  alt="main banner"
                />
                <div className="small-banner-content position-absolute">
                  <h4>Best Sake</h4>
                  <h5>iPad S13+ Pro.</h5>
                  <p>
                    From $999.00 <br /> or $41.62/mo.
                  </p>
                </div>
              </div>
              <div className="small-banner position-relative">
                <img
                  src="images/catbanner-02.jpg"
                  className="img-fluid rounded-3"
                  alt="main banner"
                />
                <div className="small-banner-content position-absolute">
                  <h4>NEW ARRIVAL</h4>
                  <h5>But IPad Air</h5>
                  <p>
                    From $999.00 <br /> or $41.62/mo.
                  </p>
                </div>
              </div>
              <div className="small-banner position-relative ">
                <img
                  src="images/catbanner-03.jpg"
                  className="img-fluid rounded-3"
                  alt="main banner"
                />
                <div className="small-banner-content position-absolute">
                  <h4>NEW ARRIVAL</h4>
                  <h5>But IPad Air</h5>
                  <p>
                    From $999.00 <br /> or $41.62/mo.
                  </p>
                </div>
              </div>
              <div className="small-banner position-relative ">
                <img
                  src="images/catbanner-04.jpg"
                  className="img-fluid rounded-3"
                  alt="main banner"
                />
                <div className="small-banner-content position-absolute">
                  <h4>NEW ARRIVAL</h4>
                  <h5>But IPad Air</h5>
                  <p>
                    From $999.00 <br /> or $41.62/mo.
                  </p>
                </div>
              </div>
            </div>
          </div>
        </div>
      </Container>

      <Container class1="featured-wrapper py-5 home-wrapper-2">
        <div className="row">
          <div className="col-12">
            <h3 className="section-heading">Featured Collection</h3>
          </div>

          {products.map((product) => (
            <div
              className={"gr-2 col-3"}
              key={product.ISBN}
              onClick={() => handleProductClick(product.inventory.id)}
            >
              <div className="product-card position-relative">
                {/* <div className="product-image">
                  {product.inventory.skus.length > 1 ? (
                    <>
                      <img
                        src={product.inventory.skus[0].options.images[0]}
                        className="img-fluid"
                        alt="product image"
                      />
                      <img
                        src={product.inventory.skus[1].options.images[0]}
                        className="img-fluid"
                        alt="product image"
                      />
                    </>
                  ) : (
                    <img
                      src={product.inventory.skus[0].options.images[0]}
                      className="img-fluid"
                      alt="product image"
                    />
                  )}
                </div> */}

                <div className="product-details">
                  {/* <h6 className="brand">
                    {product.inventory.categories.join(", ")}
                  </h6> */}
                  <h5 className="product-title">{product.title}</h5>

                  <ReactStars
                    count={5}
                    size={24}
                    value={4}
                    edit={false}
                    activeColor="#ffd700"
                  />

                  <p className="price">{product.price} VND</p>
                </div>
              </div>
            </div>
          ))}
        </div>
      </Container>

      {/* text running */}
      <Container class1="marque-wrapper home-wrapper-2 py-5">
        <div className="row">
          <div className="col-12">
            <div className="marquee-inner-wrapper card-wrapper">
              <Marquee className="d-flex">
                <div className="mx-4 w-25">
                  <img src="images/brand-01.png" alt="brand" />
                </div>
                <div className="mx-4 w-25">
                  <img src="images/brand-02.png" alt="brand" />
                </div>
                <div className="mx-4 w-25">
                  <img src="images/brand-03.png" alt="brand" />
                </div>
                <div className="mx-4 w-25">
                  <img src="images/brand-04.png" alt="brand" />
                </div>
                <div className="mx-4 w-25">
                  <img src="images/brand-05.png" alt="brand" />
                </div>
                <div className="mx-4 w-25">
                  <img src="images/brand-06.png" alt="brand" />
                </div>
                <div className="mx-4 w-25">
                  <img src="images/brand-07.png" alt="brand" />
                </div>
                <div className="mx-4 w-25">
                  <img src="images/brand-08.png" alt="brand" />
                </div>
              </Marquee>
            </div>
          </div>
        </div>
      </Container>
    </>
  );
};

export default Home;
