import React from "react";
import "./App.css";
import { BrowserRouter, Route, Routes } from "react-router-dom";
//import "./assets/scss/styles.scss";
import HomeComponent from "./components/home.component";
// import ResultComponent from "./components/result.component";
// import SolutionComponent from "./components/solution.component";
import WrapperComponent from "./components/wrapper.component";

function App() {
  return (
    <main> 
        <BrowserRouter>
          <Routes>
            <Route path="/" element={<HomeComponent />}></Route>
            <Route path="/user/*" element={<WrapperComponent/>} />
            {/* <Route path="/user/*" element={<ResultComponent />}></Route> */}
            {/* <Route path="/solution/*" element={<SolutionComponent />}></Route> */}
            
				</Routes>
        </BrowserRouter>
    </main>
  );
}

export default App;
