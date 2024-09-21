// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.8.2 <0.9.0;

contract BubbleSort{
    uint8[] public nums;
    constructor(uint8[] memory data) {
        nums = data;
    }

    function sort() public payable{
        uint8 temp;
        uint256 len = nums.length;
        if(len>20) revert() ;
        for(uint256 i=0; i<len; i++){
            for(uint256 j=i+1; j<len; j++){
                if(nums[j]<nums[i]){
                    temp = nums[j];
                    nums[j] = nums[i];
                    nums[i] = temp;
                }
            }
        }   
    }

    function getNums()public view returns(uint8[] memory){
        return nums;
    }
}