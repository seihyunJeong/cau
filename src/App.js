import React from "react";
import "./App.css";
import { BrowserRouter, Route, Routes, Link } from "react-router-dom";
//import "./assets/scss/styles.scss";
import HomeComponent from "./components/home.component";
import ResultComponent from "./components/result.component";

function App() {
  return (
    <main> 
        <BrowserRouter>
          <Routes>
            <Route path="/" element={<HomeComponent />}></Route>
            <Route path="/user/*" element={<ResultComponent />}></Route>
            
				</Routes>
        </BrowserRouter>
    </main>
  );
}

export default App;
