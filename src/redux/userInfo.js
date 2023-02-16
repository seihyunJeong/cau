import { createSlice } from "@reduxjs/toolkit";

export function getUsersThunk(platform, accessToken) {
  
}

export const userInfo = createSlice({
  name: "userInfo",
  initialState: {
    // userInfo: {
    //   id: 0,
    //   institute: "",
    //   date: "",
    //   name: "",
    //   gender: "",
    //   birth: "",
    //   age: 0,
    //   height: 0,
    //   height_avg: 0.0,
    //   weight: 0,
    //   weight_avg: 0.0,
    //   waist_length: 0,
    //   waist_length_avg: 0.0,
    //   flexibility: 0,
    //   muscular_strength: 0,
    //   quickness: 0,
    //   agility: 0,
    //   equilibrium: 0,
    //   coordination: 0,
    //   flexibility_std: 0,
    //   muscular_strength_score: 0,
    //   quickness_score: 0,
    //   agility_score: 0,
    //   equilibrium_score: 0,
    //   coordination_score: 0,
    //   flexibility_total_score: 0,
    //   muscular_strength_total_score: 0,
    //   quickness_total_score: 0,
    //   agility_total_score: 0,
    //   equilibrium_total_score: 0,
    //   coordination_total_score: 0,
    //   comment1: "",
    //   comment2: "",
    //   comment3: "",
    // },
    userInfo: [],
  },
  reducers: {
    getUserInformationStart: (state, action) => {
      return {
        ...state,
        loading: true,
      };
    },
    setUserInformation: (state, action) => {
      return {
        ...state,
        userInfo: action.payload,
        // userInfo: {
        //   id: action.payload.id,
        //   institute: action.payload.institute,
        //   date: action.payload.date,
        //   name: action.payload.name,
        //   gender: action.payload.gender,
        //   birth: action.payload.birth,
        //   age: action.payload.age,
        //   height: action.payload.height,
        //   height_avg: action.payload.height_avg,
        //   weight: action.payload.weight,
        //   weight_avg: action.payload.weight_avg,
        //   waist_length: action.payload.waist_length,
        //   waist_length_avg: action.payload.waist_length_avg,
        //   flexibility: action.payload.flexibility,
        //   muscular_strength: action.payload.muscular_strength,
        //   quickness: action.payload.quickness,
        //   agility: action.payload.agility,
        //   equilibrium: action.payload.equilibrium,
        //   coordination: action.payload.coordination,
        //   flexibility_std: action.payload.flexibility_std,
        //   muscular_strength_score: action.payload.muscular_strength_score,
        //   quickness_score: action.payload.quickness_score,
        //   agility_score: action.payload.agility_score,
        //   equilibrium_score: action.payload.equilibrium_score,
        //   coordination_score: action.payload.coordination_score,
        //   flexibility_total_score: action.payload.flexibility_total_score,
        //   muscular_strength_total_score: action.payload.muscular_strength_total_score,
        //   quickness_total_score: action.payload.quickness_total_score,
        //   agility_total_score: action.payload.agility_total_score,
        //   equilibrium_total_score: action.payload.equilibrium_total_score,
        //   coordination_total_score: action.payload.coordination_total_score,
        //   comment1: action.payload.comment1,
        //   comment2: action.payload.comment2,
        //   comment3: action.payload.comment3,
        // },
        loading: false,
      };
    },
    getUserInformationFailed: (state, action) => {
      return {
        ...state,
        loading: false,
      };
    },
  },
});

export const {
  getUserInformationStart,
  setUserInformation,
  getUserInformationFailed,
} = userInfo.actions;

export default userInfo.reducer;
