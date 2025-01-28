import { createSlice } from "@reduxjs/toolkit";

export function getSolutionsThunk(platform, accessToken) {
  
}

export const solutionInfo = createSlice({
  name: "solutionInfo",
  initialState: {
    solutionInfo: [],
  },
  reducers: {
    getSolutionInformationStart: (state, action) => {
      return {
        ...state,
        loading: true,
      };
    },
    setSolutionInformation: (state, action) => {
      return {
        ...state,
        solutionInfo: action.payload,
        // solutionInfo: {
        // },
        loading: false,
      };
    },
    getSolutionInformationFailed: (state, action) => {
      return {
        ...state,
        loading: false,
      };
    },
  },
});

export const {
  getSolutionInformationStart,
  setSolutionInformation,
  getSolutionInformationFailed,
} = solutionInfo.actions;

export default solutionInfo.reducer;
