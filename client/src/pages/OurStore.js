import React, { useEffect, useState } from "react";
import axios from "axios";
import { Link, useParams, useNavigate } from "react-router-dom";
import { BsSearch } from "react-icons/bs";
import BreadCrumb from "../components/BreadCrumb";
import Meta from "../components/Meta";
import ReactStars from "react-rating-stars-component";
import ProductCard from "../components/ProductCard";
import Color from "../components/Color";
import Container from "../components/Container";
const BackendPORT = 5000;
const OurStore = () => {
  let {id} = useParams();
  const navigate = useNavigate();
  const [grid, setGrid] = useState(4);
  const [searchQuery, setSearchQuery] = useState('');
  const [products, setProducts] = useState([]);
  const [clicked, setClicked] = useState(false);
  const [searchCategory , setSearchCategory] = useState('');
  // useEffect(() =>{
  //   axios.get(`http://localhost:${BackendPORT}/FeaturedCollection`).then((response)=>{
  //     console.log(response.data);
  //     setProducts(response.data);
  //     console.log(products);
  //   });
  // }, [id])
  // useEffect(() => {
  //   console.log("printing products")
  //   console.log(products);
  //   // console.log(products[0])
  // }, [products]);

  const handleSearchInputChange = (event) => {
    setSearchQuery(event.target.value);
  };
  const [selectedCategory, setSelectedCategory] = useState('');

  const handleCategoryClick = (category) => {
    if (category === 'None') {
      setSelectedCategory('');
    }else {
      setSelectedCategory(category);
    }
    
  };

  useEffect(() => {
    console.log('Selected category:', selectedCategory);
  }, [selectedCategory]);


  const handleSearchClick = async () => {
    try {
      // const response = await axios.get(
      //   `http://localhost:${BackendPORT}/ourProduct?search=${searchQuery}`
      // );
      const response = await axios.get(
        `http://localhost:${BackendPORT}/ourProduct?search=${searchQuery}&category=${selectedCategory}`
      );
      console.log("--------> response.data");
      console.log(response.data);
      setProducts(response.data);
      
    } catch (error) {
      console.error('Error fetching products:', error);
    }
  };
  
  
  const handleProductClick = (productId) => {
    navigate(`/product/${productId}`);
  };
  return (
    <>
      <Meta title={"Our Store"} />
      <BreadCrumb title="Our Store" />
      <Container class1="store-wrapper home-wrapper-2 py-5">
        <div className="row">
          <div className="col-3">
            <div className="filter-card mb-3">
              
            </div>

            <div className="filter-card mb-3">
              <h3 className="filter-title">Filter By</h3>
              <div>
                
                <div className="col-12">
                  <div className="input-group">
                    <input
                      type="text"
                      className="form-control py-2"
                      placeholder="Search Product Here..."
                      aria-label="Search Product Here..."
                      aria-describedby="basic-addon2"
                      value={searchQuery}
                      onChange={handleSearchInputChange}
                    />
                    {/* <span className="input-group-text p-3" id="basic-addon2">
                      <BsSearch className="fs-6" />
                    </span> */}
                    <button className="btn btn-primary" onClick={handleSearchClick}>
                        Search
                      </button>
                  </div>
                </div>

                <div>
      <h5 className="sub-title">Shop By Categories</h5>
      <div>
        <ul className="ps-0">
          <li onClick={() => handleCategoryClick('Electronics')}>Electronics</li>
          <li onClick={() => handleCategoryClick('Accessories')}>Accessories</li>
          <li onClick={() => handleCategoryClick('Computers')}>Computers</li>
          <li onClick={() => handleCategoryClick('Peripherals')}>Peripherals</li>
          <li onClick={() => handleCategoryClick('Storage Devices')}>Storage Devices</li>
          <li onClick={() => handleCategoryClick('None')}>None</li>
        </ul>
      </div>
      {selectedCategory && (
        <div>
          <h6>Selected Category: {selectedCategory}</h6>
        </div>
      )}
    </div>

                <h5 className="sub-title">Price</h5>
                <div className="d-flex align-items-center gap-10">
                  <div className="form-floating">
                    <input
                      type="email"
                      className="form-control"
                      id="floatingInput"
                      placeholder="From"
                    />
                    <label htmlFor="floatingInput">From</label>
                  </div>
                  <div className="form-floating">
                    <input
                      type="email"
                      className="form-control"
                      id="floatingInput1"
                      placeholder="To"
                    />
                    <label htmlFor="floatingInput1">To</label>
                  </div>
                </div>
                
                

              </div>
            </div>
            <div className="filter-card mb-3">
              <h3 className="filter-title">Product Tags</h3>
              <div>
                <div className="product-tags d-flex flex-wrap align-items-center gap-10">
                  <span className="badge bg-light text-secondary rounded-3 py-2 px-3">
                    Headphone
                  </span>
                  <span className="badge bg-light text-secondary rounded-3 py-2 px-3">
                    Laptop
                  </span>
                  <span className="badge bg-light text-secondary rounded-3 py-2 px-3">
                    Mobile
                  </span>
                  <span className="badge bg-light text-secondary rounded-3 py-2 px-3">
                    Wire
                  </span>
                </div>
              </div>
            </div>
            <div className="filter-card mb-3">
              <h3 className="filter-title">Random Product</h3>
              <div>
                <div className="random-products mb-3 d-flex">
                  <div className="w-50">
                    <img
                      src="images/watch.jpg"
                      className="img-fluid"
                      alt="watch"
                    />
                  </div>
                  <div className="w-50">
                    <h5>
                      Kids headphones bulk 10 pack multi colored for students
                    </h5>
                    <ReactStars
                      count={5}
                      size={24}
                      value={4}
                      edit={false}
                      activeColor="#ffd700"
                    />
                    <b>$ 300</b>
                  </div>
                </div>
                <div className="random-products d-flex">
                  <div className="w-50">
                    <img
                      src="images/watch.jpg"
                      className="img-fluid"
                      alt="watch"
                    />
                  </div>
                  <div className="w-50">
                    <h5>
                      Kids headphones bulk 10 pack multi colored for students
                    </h5>
                    <ReactStars
                      count={5}
                      size={24}
                      value={4}
                      edit={false}
                      activeColor="#ffd700"
                    />
                    <b>$ 300</b>
                  </div>

                </div>
              </div>
            </div>
          </div>
          <div className="col-9">
            <div className="filter-sort-grid mb-4">
              <div className="d-flex justify-content-between align-items-center">
                <div className="d-flex align-items-center gap-10">
                  <p className="mb-0 d-block" style={{ width: "100px" }}>
                    Sort By:
                  </p>
                  <select
                    name=""
                    defaultValue={"manula"}
                    className="form-control form-select"
                    id=""
                  >
                    <option value="manual">Featured</option>
                    <option value="best-selling">Best selling</option>
                    <option value="title-ascending">Alphabetically, A-Z</option>
                    <option value="title-descending">
                      Alphabetically, Z-A
                    </option>
                    <option value="price-ascending">Price, low to high</option>
                    <option value="price-descending">Price, high to low</option>
                    <option value="created-ascending">Date, old to new</option>
                    <option value="created-descending">Date, new to old</option>
                  </select>
                </div>
                <div className="d-flex align-items-center gap-10">
                  <p className="totalproducts mb-0">21 Products</p>
                  <div className="d-flex gap-10 align-items-center grid">
                    <img
                      onClick={() => {
                        setGrid(3);
                      }}
                      src="images/gr4.svg"
                      className="d-block img-fluid"
                      alt="grid"
                    />
                    <img
                      onClick={() => {
                        setGrid(4);
                      }}
                      src="images/gr3.svg"
                      className="d-block img-fluid"
                      alt="grid"
                    />
                    <img
                      onClick={() => {
                        setGrid(6);
                      }}
                      src="images/gr2.svg"
                      className="d-block img-fluid"
                      alt="grid"
                    />

                    <img
                      onClick={() => {
                        setGrid(12);
                      }}
                      src="images/gr.svg"
                      className="d-block img-fluid"
                      alt="grid"
                    />
                  </div>
                </div>
              </div>
            </div>
            <div className="products-list pb-5">
              <div className="d-flex gap-10 flex-wrap">
              {products.map((product) => (
                <div className={"gr-2 col-3"} key={product.id} onClick={() => handleProductClick(product.id)}>
                  <div className="product-card position-relative">
                    <div className="product-image">
                      {Array.isArray(product.images) && product.images.length >  1 ? (
                        <React.Fragment>
                          <img src={product.images[0]} className="img-fluid" alt="product image" />
                          <img src={product.images[1]} className="img-fluid" alt="product image" />
                        </React.Fragment>
                      ) : (
                        <img src={product.images[0]} className="img-fluid" alt="product image" />
                      )}
                    </div>
                    {/* <h6 className="brand">{product.inventory.categories.join(', ')}</h6> */}
                    <h5 className="product-title">{product.item}</h5>
                    <p className="price">${product.min_price}</p>
                  </div>
                </div>
                
              ))}
              
       
              </div>
              
            </div>
          </div>
        </div>
      </Container>
    </>
  );
};

export default OurStore;
