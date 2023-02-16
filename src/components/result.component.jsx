import React, { useState, useEffect, Fragment, PureComponent } from 'react';
import { Container, Row, Col } from "react-bootstrap";
import { useLocation } from "react-router-dom"
import { useDispatch, useSelector } from "react-redux";

import { Radar, RadarChart, PolarGrid, PolarAngleAxis, PolarRadiusAxis, ResponsiveContainer } from 'recharts';

const ResultComponent = (props) => {
    //const {id, institute, date, name, gender, birth, age, height, height_avg, weight, weight_avg, waist_length, waist_length_avg, flexibility, muscular_strength, quickness, agility, equilibrium, coordination, flexibility_std, muscular_strength_score, quickness_score, agility_score, equilibrium_score, coordination_score, flexibility_total_score, muscular_strength_total_score, quickness_total_score, agility_total_score, equilibrium_total_score, coordination_total_score, comment1, comment2, comment3} = state;
    const userInformation = useSelector((state) => state.userInfo.userInfo);
    const [user, setUser] = useState()
    const location = useLocation();

    useEffect(() => {
      if(userInformation !== []){
        let user_id = location.pathname.split('/')[2]
        
        setUser(userInformation.filter(user => user.id == user_id)[0])
        console.log(user)
        //console.log(user.institute)
      }
    }, [userInformation])
    

    const data = [
    {
      subject: '근력·근지구력',
      A: user && user.muscular_strength,
      fullMark: user && user.muscular_strength_total_score,
    },
    {
      subject: '순발력',
      A: user && user.quickness,
      fullMark: user && user.quickness_total_score,
    },
    {
      subject: '민첩성',
      A: user && user.agility,
      fullMark: user && user.agility_total_score,
    },
    {
      subject: '평형성',
      A: user && user.equilibrium,
      fullMark: user && user.equilibrium_total_score,
    },
    {
      subject: '협응력',
      A: user && user.coordination,
      fullMark: user && user.coordination_total_score,
    },
    {
      subject: '유연성',
      A: user && user.flexibility,
      fullMark: user && user.flexibility_total_score,
    },
  ];

  const bpa_data = [
    {
      id: 1,
      title: '유연성',
      image: '/assets/images/cau/002.png',
      detail: '앉아 윗몸 앞으로 굽히기',
      number: user && user.flexibility + ' cm',
      smile: user && user.flexibility_score,
      eval: user && user.flexibility_eval
    },
    {
      id: 2,
      title: '근력·근지구력',
      image: '/assets/images/cau/003.png',
      detail: '벽 대고 무릎 굽히기',
      number: user && user.muscular_strength + ' 초',
      smile: user && user.muscular_strength_score,
      eval: user && user.muscular_strength_eval
    },
    {
      id: 3,
      title: '순발력',
      image: '/assets/images/cau/004.png',
      detail: '제자리 멀리 뛰기',
      number: user && user.quickness + ' cm',
      smile: user && user.quickness_score,
      eval: user && user.quickness_eval
    },
    {
      id: 4,
      title: '민첩성',
      image: '/assets/images/cau/005.png',
      detail: '장애물 왕복 달리기',
      number: user && user.agility + ' 초',
      smile: user && user.agility_score,
      eval: user && user.agility_eval
    },
    {
      id: 5,
      title: '평형성',
      image: '/assets/images/cau/006.png',
      detail: '한 발 서기',
      number: user && user.equilibrium + ' 초',
      smile: user && user.equilibrium_score,
      eval: user && user.equilibrium_eval
    },
    {
      id: 6,
      title: '협응력',
      image: '/assets/images/cau/007.png',
      detail: '공 잡기',
      number: user && user.coordination + ' 회',
      smile: user && user.coordination_score,
      eval: user && user.coordination_eval
    }
  ];

  const rubricImageStyle = {
    height: '100px', 
  }

  const rubricSmileStyle = {
    height: '25px', 
  }
  
  return (
    <Fragment>
      {user &&
      <div>
        
          {/* <div style={{display: 'flex',  justifyContent:'left', alignItems:'center'}}>
            <button class='lezada-button lezada-button--medium' onClick={() => {
              var printContents = document.getElementById('report').innerHTML;
              var originalContents = document.body.innerHTML;
              document.body.innerHTML = printContents;
              window.print();
              document.body.innerHTML = originalContents;
              }}>PRINT</button>
          </div> */}
          
          
          
          <div id='report'>
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
                {/* <div id='abc' style={{width: '100%', height: '104px', position: 'absolute', zIndex:'10',  top: '200px', paddingRight: '280px'}}>
                  <ul style={{display: 'flex', justifyContent: 'center'}}>
                    <li style={{float: 'left', listStyle: 'none'}}>
                      <div style={{width: '80px'}}></div>
                    </li>
                    <li style={{float: 'left', listStyle: 'none'}}>
                      <div style={{width: '10px'}}>
                        <img  alt='no' style={{width: '40px', zIndex: 10}} src={process.env.PUBLIC_URL + "/assets/images/cau/connector.png"}/>
                      </div>
                    </li>
                    <li style={{float: 'left', listStyle: 'none'}}>
                      <div style={{width: '500px'}}>&nbsp;</div>
                    </li>
                    <li style={{float: 'left', listStyle: 'none'}}>
                      <div style={{width: '10px'}}>
                        <img  alt='no' style={{width: '40px', zIndex: 10}} src={process.env.PUBLIC_URL + "/assets/images/cau/connector.png"}/>
                      </div>
                    </li>
                  </ul>
                </div> */}
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
                  
                <Row>
                  <Col sm={1}/>
                  <Col sm={2}>
                    <font style={{color: '#008feb', fontWeight: 'bold', fontSize: '15px', fontFamily: 'gmarketSansTTFBold'}}>| 체격</font>
                  </Col>
                  <Col sm={9}/>
                </Row>
                
                <Row>
                  <Col sm={1}/>
                  <Col sm={2}>
                    <Row>
                      <div style={{width: '120px', height: '30px', display: 'flex',   justifyContent:'center',  alignItems:'center',  border: '10px'}}><font style={{color: 'white'}}></font></div>
                    </Row>
                    <br/>
                    <Row>
                      <div style={{backgroundColor: '#008feb', width: '120px', height: '30px', display: 'flex',   justifyContent:'center',  alignItems:'center', }}><font style={{fontFamily: 'gmarketSansTTFMedium', fontSize: '11px', color: 'white', fontWeight:'bold'}}>신장</font></div>
                    </Row>
                    <br/>
                    <Row>
                      <div style={{backgroundColor: '#008feb', width: '120px', height: '30px', display: 'flex',   justifyContent:'center',  alignItems:'center', }}><font style={{fontFamily: 'gmarketSansTTFMedium', fontSize: '11px', color: 'white', fontWeight:'bold'}}>체중</font></div>
                    </Row>
                    <br/>
                    <Row>
                      <div style={{backgroundColor: '#008feb', width: '120px', height: '30px', display: 'flex',   justifyContent:'center',  alignItems:'center', }}><font style={{fontFamily: 'gmarketSansTTFMedium', fontSize: '11px', color: 'white', fontWeight:'bold'}}>허리둘레</font></div>
                    </Row>
                  </Col>
                  <Col sm={2}>
                    <Row>
                      <div style={{backgroundColor: '#f3f3f3', width: '120px', height: '30px', display: 'flex',   justifyContent:'center',  alignItems:'center', }}><font style={{fontFamily: 'gmarketSansTTFMedium', fontSize: '11px'}}>측정치</font></div>
                    </Row>
                    <br/>
                    <Row>
                      <div style={{width: '120px', height: '30px', display: 'flex',   justifyContent:'center',  alignItems:'center',  border: '10px'}}><font style={{fontFamily: 'gmarketSansTTFLight', fontSize: '11px'}}>{user.height} cm</font></div>
                    </Row>
                    <br/>
                    <Row>
                      <div style={{width: '120px', height: '30px', display: 'flex',   justifyContent:'center',  alignItems:'center',  border: '10px'}}><font style={{fontFamily: 'gmarketSansTTFLight', fontSize: '11px'}}>{user.weight} kg</font></div>
                    </Row>
                    <br/>
                    <Row>
                      <div style={{width: '120px', height: '30px', display: 'flex',   justifyContent:'center',  alignItems:'center',  border: '10px'}}><font style={{fontFamily: 'gmarketSansTTFLight', fontSize: '11px'}}>{user.waist_length} cm</font></div>
                    </Row>
                  </Col>
                  <Col sm={2}>
                    <Row>
                      <div style={{backgroundColor: '#f3f3f3', width: '120px', height: '30px', display: 'flex',   justifyContent:'center',  alignItems:'center', }}><font style={{fontFamily: 'gmarketSansTTFMedium', fontSize: '11px'}}>또래 평균치</font></div>
                    </Row>
                    <br/>
                    <Row>
                      <div style={{width: '120px', height: '30px', display: 'flex',   justifyContent:'center',  alignItems:'center',  border: '10px'}}><font style={{fontFamily: 'gmarketSansTTFLight', fontSize: '11px'}}>{user.height_avg} cm</font></div>
                    </Row>
                    <br/>
                    <Row>
                      <div style={{width: '120px', height: '30px', display: 'flex',   justifyContent:'center',  alignItems:'center',  border: '10px'}}><font style={{fontFamily: 'gmarketSansTTFLight', fontSize: '11px'}}>{user.weight_avg} kg</font></div>
                    </Row>
                    <br/>
                    <Row>
                      <div style={{width: '120px', height: '30px', display: 'flex',   justifyContent:'center',  alignItems:'center',  border: '10px'}}><font style={{fontFamily: 'gmarketSansTTFLight', fontSize: '11px'}}>{user.waist_length_avg} cm</font></div>
                    </Row>
                  </Col>
                  <Col sm={3}>
                    {/* graph*/}
                    
                      <ResponsiveContainer width="100%" height="100%">
                        <RadarChart cx="50%" cy="50%" outerRadius="80%" data={data}>
                          <PolarGrid />
                          <PolarAngleAxis dataKey="subject" />
                          <PolarRadiusAxis />
                          <Radar name="Mike" dataKey="A" stroke="#008feb" fill="#008feb" fillOpacity={0.6} />
                        </RadarChart>
                      </ResponsiveContainer>
                    
                  </Col>
                  <Col sm={2}/>
                </Row>
                <br/>
                <br/>
                <br/>
                <Row>
                  <Col sm={1}/>
                  <Col sm={2}>
                    <font style={{color: '#008feb', fontWeight: 'bold', fontSize: '15px', fontFamily: 'gmarketSansTTFBold'}}>| 기초운동능력</font> 
                  </Col>
                  <Col sm={9}/>
                </Row>

                <br/>
                <Row style={{display: 'flex', justifyContent: 'center', textAlign: 'center'}}>
                  <ul style={{ display:"flex", gap: "8px", padding:"0"}}>
                    {bpa_data && bpa_data.map((bpa_data, index) => (
                      <li style={{display: 'flex', flexDirection:"column", alignItems:"center"}}>
                        <div style={{width: '120px', textAlign: 'center'}}>
                          <font style={{fontFamily: 'gmarketSansTTFMedium', fontSize: '12px', fontWeight: 'bold'}}>{bpa_data.title}</font>
                        </div>
                        {/* <br/> */}
                        <div style={{width: '120px', textAlign: 'center'}}>
                          <img  alt='no' style={rubricImageStyle} src={process.env.PUBLIC_URL + bpa_data.image}/>
                        </div>
                        <div style={{textAlign: 'center'}}><font style={{fontFamily: 'gmarketSansTTFLight', fontSize: '10px', fontWeight: 'bold'}}>{bpa_data.detail}</font></div>
                        {/* <br/> */}
                        <div style={{textAlign: 'center'}}><font style={{fontFamily: 'gmarketSansTTFLight', fontSize: '10px', fontWeight: 'bold'}}>{bpa_data.number}</font></div>
                        {/* <br/> */}
                        <div style={{display: 'flex', flexDirection:"column", justifyContent: 'center', textAlign: 'center'}}>
                          <ul style={{display: 'inline-block', padding:"0"}}>
                            <li style={{float: 'left', listStyle: 'none'}}>
                              <img  alt='no' style={rubricSmileStyle} src={process.env.PUBLIC_URL + "/assets/images/cau/008.png"}/>
                            </li>
                            <li style={{float: 'left', listStyle: 'none'}}>
                              {bpa_data.smile < 2?
                                <img  alt='no' style={rubricSmileStyle} src={process.env.PUBLIC_URL + "/assets/images/cau/009.png"}/>
                                :
                                <img  alt='no' style={rubricSmileStyle} src={process.env.PUBLIC_URL + "/assets/images/cau/008.png"}/>
                              } 
                            </li>
                            <li style={{float: 'left', listStyle: 'none'}}>
                              {bpa_data.smile < 3?
                                <img  alt='no' style={rubricSmileStyle} src={process.env.PUBLIC_URL + "/assets/images/cau/009.png"}/>
                                :
                                <img  alt='no' style={rubricSmileStyle} src={process.env.PUBLIC_URL + "/assets/images/cau/008.png"}/>
                              } 
                            </li>
                          </ul>
                          {/* <br/> */}
                          <div style={{diplay: 'block'}}>
                            <font style={{ fontFamily: 'gmarketSansTTFLight', fontSize: '10px'}}>{bpa_data.eval}</font>
                          </div>
                        </div>
                      </li>

                    )
                    )}
                  </ul>
                </Row>

                <br/>
                <br/>
                <Row>
                  <Col sm={1}/>
                  <Col sm={2}>
                    <font style={{color: '#008feb', fontWeight: 'bold', fontSize: '15px', fontFamily: 'gmarketSansTTFBold'}}>| 종합소견</font> 
                  </Col>
                  <Col sm={9}/>
                </Row>
                <br/>
                <Row style={{display: 'flex', justifyContent: 'center', textAlign: 'center'}}>
                  <ul style={{ display:"flex", gap: "27px", padding:"0"}}>
                    
                    <li style={{display: 'inline-block'}}>
                      <div style={{width: '95px', height: '30px', textAlign: 'center', backgroundColor: '#f3f3f3', display: 'flex', justifyContent: 'center', alignItems: 'center'}}>
                        <font style={{fontFamily: 'gmarketSansTTFMedium', fontSize: '11px'}}>{bpa_data[0].title}</font>
                      </div>
                      <br/>
                      <div style={{width: '95px', textAlign: 'center', display: 'flex', justifyContent: 'center', alignItems: 'center', border: 'dashed #f3f3f3'}}>
                        <ul style={{display: 'inline-block', paddingLeft: '0px'}}>
                          <li style={{float: 'left', listStyle: 'none'}}>
                            <img  alt='no' style={rubricSmileStyle} src={process.env.PUBLIC_URL + "/assets/images/cau/008.png"}/>
                          </li>
                          <li style={{float: 'left', listStyle: 'none'}}>
                            {user.flexibility_final_score < 2 &&
                              <img  alt='no' style={rubricSmileStyle} src={process.env.PUBLIC_URL + "/assets/images/cau/008.png"}/>
                            } 
                          </li>
                          <li style={{float: 'left', listStyle: 'none'}}>
                            {user.flexibility_final_score< 3 &&
                              <img  alt='no' style={rubricSmileStyle} src={process.env.PUBLIC_URL + "/assets/images/cau/008.png"}/>
                            } 
                          </li>
                        </ul>
                      </div>
                    </li>
                    
                    <li style={{display: 'inline-block'}}>
                      <div style={{width: '95px', height: '30px', textAlign: 'center', backgroundColor: '#f3f3f3', display: 'flex', justifyContent: 'center', alignItems: 'center'}}>
                        <font style={{fontFamily: 'gmarketSansTTFMedium', fontSize: '11px'}}>{bpa_data[1].title}</font>
                      </div>
                      <br/>
                      <div style={{width: '95px', textAlign: 'center', display: 'flex', justifyContent: 'center', alignItems: 'center', border: 'dashed #f3f3f3'}}>
                        <ul style={{display: 'inline-block', paddingLeft: '0px'}}>
                          <li style={{float: 'left', listStyle: 'none'}}>
                            <img  alt='no' style={rubricSmileStyle} src={process.env.PUBLIC_URL + "/assets/images/cau/008.png"}/>
                          </li>
                          <li style={{float: 'left', listStyle: 'none'}}>
                            {user.muscular_strength_final_score < 2 &&
                              <img  alt='no' style={rubricSmileStyle} src={process.env.PUBLIC_URL + "/assets/images/cau/008.png"}/>
                            } 
                          </li>
                          <li style={{float: 'left', listStyle: 'none'}}>
                            {user.muscular_strength_final_score< 3 &&
                              <img  alt='no' style={rubricSmileStyle} src={process.env.PUBLIC_URL + "/assets/images/cau/008.png"}/>
                            } 
                          </li>
                        </ul>  
                      </div>
                    </li>
                    
                    <li style={{display: 'inline-block'}}>
                      <div style={{width: '95px', height: '30px', textAlign: 'center', backgroundColor: '#f3f3f3', display: 'flex', justifyContent: 'center', alignItems: 'center'}}>
                        <font style={{fontFamily: 'gmarketSansTTFMedium', fontSize: '11px'}}>{bpa_data[2].title}</font>
                      </div>
                      <br/>
                      <div style={{width: '95px', textAlign: 'center', display: 'flex', justifyContent: 'center', alignItems: 'center', border: 'dashed #f3f3f3'}}>
                        <ul style={{display: 'inline-block', paddingLeft: '0px'}}>
                          <li style={{float: 'left', listStyle: 'none'}}>
                            <img  alt='no' style={rubricSmileStyle} src={process.env.PUBLIC_URL + "/assets/images/cau/008.png"}/>
                          </li>
                          <li style={{float: 'left', listStyle: 'none'}}>
                            {user.quickness_final_score < 2 &&
                              <img  alt='no' style={rubricSmileStyle} src={process.env.PUBLIC_URL + "/assets/images/cau/008.png"}/>
                            } 
                          </li>
                          <li style={{float: 'left', listStyle: 'none'}}>
                            {user.quickness_final_score< 3 &&
                              <img  alt='no' style={rubricSmileStyle} src={process.env.PUBLIC_URL + "/assets/images/cau/008.png"}/>
                            } 
                          </li>
                        </ul>
                      </div>
                    </li>
                    
                    <li style={{display: 'inline-block'}}>
                      <div style={{width: '95px', height: '30px', textAlign: 'center', backgroundColor: '#f3f3f3', display: 'flex', justifyContent: 'center', alignItems: 'center'}}>
                        <font style={{fontFamily: 'gmarketSansTTFMedium', fontSize: '11px'}}>{bpa_data[3].title}</font>
                      </div>
                      <br/>
                      <div style={{width: '95px', textAlign: 'center', display: 'flex', justifyContent: 'center', alignItems: 'center', border: 'dashed #f3f3f3'}}>
                        <ul style={{display: 'inline-block', paddingLeft: '0px'}}>
                          <li style={{float: 'left', listStyle: 'none'}}>
                            <img  alt='no' style={rubricSmileStyle} src={process.env.PUBLIC_URL + "/assets/images/cau/008.png"}/>
                          </li>
                          <li style={{float: 'left', listStyle: 'none'}}>
                            {user.agility_final_score < 2 &&
                              <img  alt='no' style={rubricSmileStyle} src={process.env.PUBLIC_URL + "/assets/images/cau/008.png"}/>
                            } 
                          </li>
                          <li style={{float: 'left', listStyle: 'none'}}>
                            {user.agility_final_score< 3 &&
                              <img  alt='no' style={rubricSmileStyle} src={process.env.PUBLIC_URL + "/assets/images/cau/008.png"}/>
                            } 
                          </li>
                        </ul>
                      </div>
                    </li>
                    
                    <li style={{display: 'inline-block'}}>
                      <div style={{width: '95px', height: '30px', textAlign: 'center', backgroundColor: '#f3f3f3', display: 'flex', justifyContent: 'center', alignItems: 'center'}}>
                        <font style={{fontFamily: 'gmarketSansTTFMedium', fontSize: '11px'}}>{bpa_data[4].title}</font>
                      </div>
                      <br/>
                      <div style={{width: '95px', textAlign: 'center', display: 'flex', justifyContent: 'center', alignItems: 'center', border: 'dashed #f3f3f3'}}>
                        <ul style={{display: 'inline-block', paddingLeft: '0px'}}>
                          <li style={{float: 'left', listStyle: 'none'}}>
                            <img  alt='no' style={rubricSmileStyle} src={process.env.PUBLIC_URL + "/assets/images/cau/008.png"}/>
                          </li>
                          <li style={{float: 'left', listStyle: 'none'}}>
                            {user.equilibrium_final_score < 2 &&
                              <img  alt='no' style={rubricSmileStyle} src={process.env.PUBLIC_URL + "/assets/images/cau/008.png"}/>
                            } 
                          </li>
                          <li style={{float: 'left', listStyle: 'none'}}>
                            {user.equilibrium_final_score< 3 &&
                              <img  alt='no' style={rubricSmileStyle} src={process.env.PUBLIC_URL + "/assets/images/cau/008.png"}/>
                            } 
                          </li>
                        </ul>
                      </div>
                    </li>
                    
                    <li style={{display: 'inline-block'}}>
                      <div style={{width: '95px', height: '30px', textAlign: 'center', backgroundColor: '#f3f3f3', display: 'flex', justifyContent: 'center', alignItems: 'center'}}>
                        <font style={{fontFamily: 'gmarketSansTTFMedium', fontSize: '11px'}}>{bpa_data[5].title}</font>
                      </div>
                      <br/>
                      <div style={{width: '95px', textAlign: 'center', display: 'flex', justifyContent: 'center', alignItems: 'center', border: 'dashed #f3f3f3'}}>
                        <ul style={{display: 'inline-block', paddingLeft: '0px'}}>
                          <li style={{float: 'left', listStyle: 'none'}}>
                            <img  alt='no' style={rubricSmileStyle} src={process.env.PUBLIC_URL + "/assets/images/cau/008.png"}/>
                          </li>
                          <li style={{float: 'left', listStyle: 'none'}}>
                            {user.coordination_final_score < 2 &&
                              <img  alt='no' style={rubricSmileStyle} src={process.env.PUBLIC_URL + "/assets/images/cau/008.png"}/>
                            } 
                          </li>
                          <li style={{float: 'left', listStyle: 'none'}}>
                            {user.coordination_final_score< 3 &&
                              <img  alt='no' style={rubricSmileStyle} src={process.env.PUBLIC_URL + "/assets/images/cau/008.png"}/>
                            } 
                          </li>
                        </ul>
                      </div>
                    </li>
                  </ul>
                </Row>
                <br/>
                
                <Row>
                  <Col sm={1}/>
                  <Col sm={10}>
                  <div style={{backgroundColor: '#c7ecff'}}>
                    <ul>
                      <li style={{listStyle: 'none'}}>
                        <div style={{height: '20px'}}></div>
                      </li>
                    </ul>
                    {'comment1' in user &&
                      <ul>  
                        <li style={{listStyle: 'none'}}>
                          <font style={{fontFamily: 'gmarketSansTTFMedium', fontSize: '15px'}}>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;- {user.comment1}</font>
                        </li>
                        <li style={{listStyle: 'none'}}>
                          <div style={{height: '5px'}}></div>
                        </li>
                      </ul>
                    }
                    {'comment2' in user &&
                      <ul>
                        <li style={{listStyle: 'none'}}>
                          <font style={{fontFamily: 'gmarketSansTTFMedium', fontSize: '15px'}}>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;- {user.comment2}</font>
                        </li>
                        <li style={{listStyle: 'none'}}>
                          <div style={{height: '5px'}}></div>
                        </li>
                      </ul>
                    }
                    {'comment3' in user ?
                      <ul>
                        <li style={{listStyle: 'none'}}>
                          <font style={{fontFamily: 'gmarketSansTTFMedium', fontSize: '15px'}}>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;- {user.comment3}</font>
                        </li>
                        <li style={{listStyle: 'none'}}>
                          <div style={{height: '10px'}}></div>
                        </li>
                      </ul>
                    :
                      <ul>
                        <li style={{listStyle: 'none'}}>
                          <div style={{height: '20px'}}></div>
                        </li>
                      </ul>
                    }                    
                    
                  </div>  
                  </Col>
                  <Col sm={1}/>
                </Row>
                <br/><br/>
              </div>
              <br/><br/><br/>
          </div>
          </div>
          
        
        
      </div>
    }      
    </Fragment>
  );
};

export default ResultComponent;
