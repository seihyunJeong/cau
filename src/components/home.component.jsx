import React, { useState, useEffect } from "react";  
import { read, utils } from 'xlsx';
import { Link } from 'react-router-dom';
import { useDispatch, useSelector } from "react-redux";
import {setUserInformation} from "../redux/userInfo"

const HomeComponent = () => {
    const dispatch = useDispatch();
    const [users, setUsers] = useState([]);
    const userInformation = useSelector((state) => state.userInfo.userInfo);

    useEffect(() => {
        if(userInformation && userInformation.length > 0){
            setUsers(userInformation)
          // console.log(user)
          // console.log(user.institute)
        }
      }, [userInformation])

    //   function ExcelDateToJSDate(serial) {
    //     var utc_days  = Math.floor(serial - 25569);
    //     var utc_value = utc_days * 86400;                                        
    //     var date_info = new Date(utc_value * 1000);
        
    //     var fractional_day = serial - Math.floor(serial) + 0.0000001;
     
    //     var total_seconds = Math.floor(86400 * fractional_day);
     
    //     var seconds = total_seconds % 60;
     
    //     total_seconds -= seconds;
     
    //     var hours = Math.floor(total_seconds / (60 * 60));
    //     var minutes = Math.floor(total_seconds / 60) % 60;
     
    //     return new Date(date_info.getFullYear(), date_info.getMonth(), date_info.getDate(), hours, minutes, seconds);
    //  }
    
    const handleImport = ($event) => {
        const files = $event.target.files;
        if (files.length) {
            const file = files[0];
            const reader = new FileReader();
            reader.onload = (event) => {
                const wb = read(event.target.result, { type: "binary" });
                const sheets = wb.SheetNames;

                if (sheets.length) {
                    const rows = utils.sheet_to_json(wb.Sheets[sheets[0]], {dateNF: 'yyyy-mm-dd', cellDates: true, raw: true});
                    console.log(rows)
                    for(let i=0; i< rows.length; i++){
                        var tempDate = new Date(Math.round((rows[i].date - 25569)*86400*1000))
                        rows[i].date =  tempDate.getFullYear() + "-" + (tempDate.getMonth()+1) + "-" + tempDate.getDate()
                        var tempBirth = new Date(Math.round((rows[i].birth - 25569)*86400*1000))
                        rows[i].birth =  tempBirth.getFullYear() + "-" + (tempBirth.getMonth()+1) + "-" + tempBirth.getDate()
                    }
                    setUsers(rows)
                    //console.log(users)
                    dispatch(setUserInformation(rows))
                }
            }
            reader.readAsArrayBuffer(file);
        }
    }

    return (
        <>
            <div className="row mb-2 mt-5">
                <div className="col-sm-6">
                    <div className="row">
                        <div className="col-md-6">
                            <div className="input-group">
                                <div className="custom-file">
                                    <input type="file" name="file" className="custom-file-input" id="inputGroupFile" required onChange={handleImport}
                                        accept=".csv, application/vnd.openxmlformats-officedocument.spreadsheetml.sheet, application/vnd.ms-excel"/>
                                    <label className="custom-file-label" htmlFor="inputGroupFile">Choose file</label>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            <div className="row">
                <div className="col-sm-11">
                    <table className="table">
                        <thead>
                            <tr>
                                <th scope="col">소속</th>
                                <th scope="col">측정일</th>
                                <th scope="col">이름</th>
                                <th scope="col">성별</th>
                                <th scope="col">생년월일</th>
                                <th scope="col">나이</th>
                                <th scope="col">신장</th>
                                <th scope="col">체중</th>
                                <th scope="col">허리둘레</th>
                                <th scope="col">유연성</th>
                                <th scope="col">근력·근지구력</th>
                                <th scope="col">순발력</th>
                                <th scope="col">민첩성</th>
                                <th scope="col">평형성</th>
                                <th scope="col">협응력</th>
                                <th scope="col">결과지</th>
                                <th scope="col">솔루션</th>
                            </tr>
                        </thead>
                        <tbody> 
                                {
                                    users.length
                                    ?
                                    users.map((user, index) => (
                                        <tr key={index}>
                                            {/* <th scope="row">{ index + 1 }</th> */}
                                            <td>{ user.institute }</td>
                                            <td>{ user.date }</td>
                                            <td>{ user.name }</td>
                                            <td>{ user.gender }</td>
                                            <td>{ user.birth }</td>
                                            <td>{ user.age }</td>
                                            <td>{ user.height }</td>
                                            <td>{ user.weight }</td>
                                            <td>{ user.waist_length }</td>
                                            <td>{ user.flexibility }</td>
                                            <td>{ user.muscular_strength }</td>
                                            <td>{ user.quickness }</td>
                                            <td>{ user.agility }</td>
                                            <td>{ user.equilibrium }</td>
                                            <td>{ user.coordination }</td>
                                            <td>{ user.solution_id_list }</td>
                                            <td>
                                                <Link 
                                                    to={`/user/${user.id}`}
                                                    
                                                    state={{
                                                        // id: user.id,
                                                        // institute: user.institute,
                                                        // date: user.date,
                                                        // name: user.name,
                                                        // gender: user.gender,
                                                        // birth: user.birth,
                                                        // age: user.age,
                                                        // height: user.height,
                                                        // height_avg: user.height_avg,
                                                        // weight: user.weight,
                                                        // weight_avg: user.weight_avg,
                                                        // waist_length: user.waist_length,
                                                        // waist_length_avg: user.waist_length_avg,
                                                        // flexibility: user.flexibility,
                                                        // muscular_strength: user.muscular_strength,
                                                        // quickness: user.quickness,
                                                        // agility: user.agility,
                                                        // equilibrium: user.equilibrium,
                                                        // coordination: user.coordination,
                                                        // flexibility_std: user.flexibility_std,
                                                        // muscular_strength_score: user.muscular_strength_score,
                                                        // quickness_score: user.quickness_score,
                                                        // agility_score: user.agility_score,
                                                        // equilibrium_score: user.equilibrium_score,
                                                        // coordination_score: user.coordination_score,
                                                        // flexibility_total_score: user.flexibility_total_score,
                                                        // muscular_strength_total_score: user.muscular_strength_total_score,
                                                        // quickness_total_score: user.quickness_total_score,
                                                        // agility_total_score: user.agility_total_score,
                                                        // equilibrium_total_score: user.equilibrium_total_score,
                                                        // coordination_total_score: user.coordination_total_score,
                                                        // comment1: user.comment1,
                                                        // comment2: user.comment2,
                                                        // comment3: user.comment3
                                                        user: user
                                                    }}
                                                >
                                                    보기
                                                </ Link>
                                            </td>
                                            {/* <td>
                                                <Link 
                                                    to={`/solution/${user.id}`}
                                                    state={{
                                                        user: user
                                                    }}
                                                >
                                                    솔루션
                                                </ Link>
                                            </td> */}
                                        </tr> 
                                    ))
                                    :
                                    <tr>
                                        <td colSpan="5" className="text-center">No Users Found.</td>
                                    </tr> 
                                }
                        </tbody>
                    </table>
                </div>
            </div>
        </>

    );
};

export default HomeComponent;
