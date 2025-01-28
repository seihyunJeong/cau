import React, { useState, useEffect, Fragment, PureComponent } from 'react';
import { Container, Row, Col } from "react-bootstrap";
import { useLocation } from "react-router-dom"
import { useDispatch, useSelector } from "react-redux";
import ResultComponent from './result.component'
import SolutionComponent from './solution.component'

import { Radar, RadarChart, PolarGrid, PolarAngleAxis, PolarRadiusAxis, ResponsiveContainer } from 'recharts';

const WrapperComponent = (props) => {
    //const {id, institute, date, name, gender, birth, age, height, height_avg, weight, weight_avg, waist_length, waist_length_avg, flexibility, muscular_strength, quickness, agility, equilibrium, coordination, flexibility_std, muscular_strength_score, quickness_score, agility_score, equilibrium_score, coordination_score, flexibility_total_score, muscular_strength_total_score, quickness_total_score, agility_total_score, equilibrium_total_score, coordination_total_score, comment1, comment2, comment3} = state;
    const userInformation = useSelector((state) => state.userInfo.userInfo);
    const [user, setUser] = useState();
    const [solutionIdList, setSolutionIdList] = useState([]);
    const location = useLocation();

    useEffect(() => {
      if (userInformation && userInformation.length > 0) {
        const user_id = location.pathname.split('/')[2];
        const selectedUser = userInformation.find((user) => user.id === Number(user_id));

        if (selectedUser) {
            setUser(selectedUser);
            console.log('user_id:', user_id);
            console.log('user:', selectedUser);

            if (selectedUser.solution_id_list) {
                const solutionIds = selectedUser.solution_id_list
                    .replace('[', '')
                    .replace(']', '')
                    .split(',')
                    .map((id) => Number(id.trim()))
                    .filter((id) => !isNaN(id));
                
                console.log('solutionIdList:', solutionIds);
                setSolutionIdList(solutionIds);
            } else {
                console.warn('solution_id_list가 존재하지 않습니다.');
            }
        } else {
            console.warn('해당 ID에 해당하는 사용자를 찾을 수 없습니다:', user_id);
        }
      }
    }, [userInformation, location.pathname])

    // let solutionIdList = [1, 2, 3, 4, 5, 6, 7];
    let maxSolutionPerPage = 2;
    let solutionPageNum = Math.ceil(solutionIdList.length / maxSolutionPerPage)

    //convert solutionIdList to sub solutionIdList per page
    const solutionIdListPerPage = Array.from({ length: solutionPageNum }, (_, i) =>
      solutionIdList.slice(i * maxSolutionPerPage, (i + 1) * maxSolutionPerPage)
    );

    // for (let i=0; i<solutionIdListPerPage.length; i++){
    //   console.log('-->', solutionIdListPerPage[i]);
    // }

  return (
    <Fragment>
      {user &&
      <div>
        <ResultComponent state= {{user: user}} />
        
        {/* <SolutionComponent state = { {user:user, solutionIdList: solutionIdList} } /> */}
        {solutionIdListPerPage.map((pageList, index) => (
          <SolutionComponent 
            key={index}
            state={{ 
              user: user, 
              solutionIdList: pageList,
              pageNumber: index + 1
            }} 
          />
        ))}
      </div>
    }      
    </Fragment>
  );
};

export default WrapperComponent;