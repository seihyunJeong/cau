import React, { useState, useEffect, Fragment, PureComponent } from 'react';
import { Container, Row, Col } from "react-bootstrap";
import { useLocation } from "react-router-dom"
import { useDispatch, useSelector } from "react-redux";

const SolutionComponent = (props) => {
  const [user, setUser] = useState();
  const [solutionIdList, setSolutionIdList] = useState([]);

  useEffect(() => {
    console.log(props.state.user);
    setUser(props.state.user); // props.data에 사용자 정보가 있다고 가정

    setSolutionIdList(props.state.solutionIdList)
    // console.log(props.state.solutionIdList);
  }, [props]);
  // const rubricImageStyle = {
  //   height: '100px', 
  // }

  // const rubricSmileStyle = {
  //   height: '25px', 
  // }
  
  return (
    <Fragment>
      {user &&
      <div>          
          <div id='solution'>
            <div style={{backgroundColor: '#008feb'}}>
              <br/><br/>
              <div style={{backgroundColor: '#FFF', borderRadius: '30px', margin: '0px auto', width: '80%', position: 'relative'}}>
                <br/><br/>
                {/* Title */}
                <Row>
                  <Col sm={2}/>
                  <Col sm={8}>
                    <div style={{display: 'flex',  justifyContent:'center', alignItems:'center'}}>
                      <font style={{fontFamily: 'gmarketSansTTFBold', fontSize: '30px', color: 'black'}}>유아 기초운동능력 측정결과</font>
                    </div>
                  </Col>
                  <Col sm={2}/>
                </Row>
                <br/>
                <Row>
                  <Col sm={2}/>
                  <Col sm={2}>
                    <font style={{fontFamily: 'gmarketSansTTFMedium', fontSize: '15px', color: 'black'}}>-소속 :</font>
                  </Col>
                  <Col sm={2}>
                    <font style={{fontFamily: 'gmarketSansTTFLight', fontSize: '15px', color: 'black', fontWeight: 'bold'}}>{user.institute}</font>
                  </Col>
                  <Col sm={2}>
                    <font style={{fontFamily: 'gmarketSansTTFMedium', fontSize: '15px', color: 'black'}}>-측정일 :</font>
                  </Col>
                  <Col sm={2}>
                    <font style={{fontFamily: 'gmarketSansTTFLight', fontSize: '15px', color: 'black', fontWeight: 'bold'}}>{user.date}</font>
                  </Col>
                </Row>
                <br/><br/>
              </div>
              <div id='abc' style={{width: '100%', height: '104px', position: 'absolute', zIndex:'10',  top: '200px'}}>
                <Row>
                  <Col sm={2}/>
                  <Col sm={2}>
                    <div style={{display: 'flex',  justifyContent:'center', alignItems:'center'}}>
                      <img  alt='no' style={{width: '40px', zIndex: 10}} src={process.env.PUBLIC_URL + "/assets/images/cau/connector.png"}/>
                    </div>
                  </Col>
                  <Col sm={4}/>
                  <Col sm={2}>
                    <div style={{display: 'flex',  justifyContent:'center', alignItems:'center'}}>
                      <img  alt='no' style={{width: '40px', zIndex: 10}} src={process.env.PUBLIC_URL + "/assets/images/cau/connector.png"}/>
                    </div>
                  </Col>
                  <Col sm={2}/>
                </Row>
              </div>
              <br/>
              <div style={{backgroundColor: '#FFF', borderRadius: '30px', margin: '0px auto', width: '80%'}}>
                {/* Content */}
                <br/><br/>
                <ul style={{textAlign: 'center'}}>
                    <li style={{display: 'inline-block'}}>
                      <div style={{width: '90px'}}>
                        <font style={{fontFamily: 'gmarketSansTTFMedium', fontSize: '12px', color: 'black', fontWeight:'bold'}}>☑ 이름 :</font>
                      </div>
                    </li>
                    <li style={{display: 'inline-block'}}>
                      <div style={{width: '90px'}}>
                        <font style={{fontFamily: 'gmarketSansTTFLight', fontSize: '11px', color: 'black', fontWeight:'bold'}}>{user.name}</font>
                      </div>
                    </li>  
                    <li style={{display: 'inline-block'}}>
                      <div style={{width: '90px'}}>
                        <font style={{fontFamily: 'gmarketSansTTFMedium', fontSize: '12px', color: 'black', fontWeight:'bold'}}>☑ 성별 :</font>
                      </div>
                    </li>  
                    <li style={{display: 'inline-block'}}>
                      <div style={{width: '90px'}}>
                        <font style={{fontFamily: 'gmarketSansTTFLight', fontSize: '11px', color: 'black', fontWeight:'bold'}}>{user.gender}</font>
                      </div>
                    </li>  
                    <li style={{display: 'inline-block'}}>
                      <div style={{width: '90px'}}>
                        <font style={{fontFamily: 'gmarketSansTTFMedium', fontSize: '12px', color: 'black', fontWeight:'bold'}}>☑ 생년월일 :</font>
                      </div>
                    </li>  
                    <li style={{display: 'inline-block'}}>
                      <div style={{width: '90px'}}>
                        <font style={{fontFamily: 'gmarketSansTTFLight', fontSize: '11px', color: 'black', fontWeight:'bold'}}>{user.birth}</font>
                      </div>
                    </li>  
                    <li style={{display: 'inline-block'}}>
                      <div style={{width: '90px'}}>
                        <font style={{fontFamily: 'gmarketSansTTFMedium', fontSize: '12px', color: 'black', fontWeight:'bold'}}>☑ 나이 :</font>
                      </div>
                    </li>  
                    <li style={{display: 'inline-block'}}>
                      <div style={{width: '90px'}}>
                        <font style={{fontFamily: 'gmarketSansTTFLight', fontSize: '11px', color: 'black', fontWeight:'bold'}}>{user.age}</font>
                      </div>
                    </li>  
                  </ul>
               
                  <hr/>
                  <br/>
                  
                {solutionIdList.length > 0 && 
                  <Fragment>
                    <Row>
                      <Col sm={1}/>
                      <Col sm={10}>
                        <img  alt='no' style={{width: '100%', zIndex: 10}} 
                          src={process.env.PUBLIC_URL + "/assets/images/solution/sample.png"}/>
                      </Col>
                      <Col sm={1}/>
                    </Row>
                    <br/><br/><br/>
                  </Fragment>
                }
                <br/><br/><br/>
                {solutionIdList.length > 1 && 
                  <Fragment>
                    <Row>
                      <Col sm={1}/>
                      <Col sm={10}>
                        <img  alt='no' style={{width: '100%', zIndex: 10}} 
                          src={process.env.PUBLIC_URL + "/assets/images/solution/sample.png"}/>
                      </Col>
                      <Col sm={1}/>
                    </Row>
                    <br/><br/><br/>
                  </Fragment>
                }
                
                
              </div>
              <br/><br/><br/>
          </div>
        </div>
      </div>
    }      
    </Fragment>
  );
};

export default SolutionComponent;
