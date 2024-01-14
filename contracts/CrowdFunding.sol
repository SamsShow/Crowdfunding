// SPDX-License-Identifier: UNLICENSED

// solidity is a strictly typed language -> specify the type of variable
pragma solidity ^0.8.9;

// In Solidity, uint256 is a data type that represents an unsigned integer with a size of 256 bits. It can hold values from 0 to 2^256-1. The uint256 data type is commonly used for representing quantities, amounts, or indices in smart contracts.

contract CrowdFunding{
    struct Campign{
        address owner;
        string title;
        string description;
        uint256 goal;
        uint256 deadline;
        uint256 currentAmount;
        string image;
        address[] donators;
        uint256[] donations;
    }

    mapping(uint256 => Campign) public campigns;
    // Maping is a key value pair

    uint256 public campignCount=0;
    // No of campigns in the contract

    // Strructure of all the functions our campign will have

// In Solidity, the string memory type is used to declare a string variable that is stored in memory.
// In Solidity, there are two types of memory: storage and memory. Storage refers to the persistent storage on the blockchain, while memory is a temporary storage area used during the execution of a function.

    function createCampign(address _owner,string memory _title, string memory _discription, uint256 _target, uint256 _deadline, string memory _image) public returns (uint256) {
        // Add an opening curly brace here
        // Your code here

        // In Solidty we have to specify the type of function if it is public or private
        // public means anyone can call this function
        // private means only the contract can call this function
        // internal means only the contract and the contracts that inherit this contract can call this function
        // external means only the contract can call this function

        // we also have to specify the return type of the function 


        Campign storage campign = campigns[campignCount];
        // storage means that the data will be stored in the blockchain
        // The campigns is an array or mapping of Campign structs. The campignCount is used as an index or key to access a specific Campign struct within the campigns array or mapping.

        // is everything Okay?
        require(campign.deadline > block.timestamp, "Deadline should be greater than current time");

        campign.owner = _owner;
        campign.title = _title;
        campign.description = _discription;
        campign.goal = _target;
        campign.deadline = _deadline;
        campign.image = _image;
        campign.currentAmount = 0;

        campignCount++;

        return campignCount -1;


    }

    function donatetoCampign(uint256 _id) public payable{
        // payable is a special keyword which means that signifies that we will send some crypto through this function
        uint256 amount = msg.value;
        // msg.value is the amount of crypto that is sent to this function
        // In Solidity, msg.value is a special global variable that contains the amount of wei (the smallest unit of ether) sent with the message (or transaction) that is currently being executed.

        Campign storage campign = campigns[_id];

        campign.donators.push(msg.sender);
        campign.donations.push(amount);

        (bool sent,) = payable(campign.owner).call{value: amount}("");

        if(sent){
            campign.currentAmount = campign.currentAmount + amount;
        }
    }

    function getDonatiors(uint256 _id) view public returns(address[] memory, uint256[] memory){
        // The view keyword in Solidity is used to indicate that a function does not modify the state of the contract. It is a way to declare that a function is read-only and does not make any changes to the contract's data.

        return (campigns[_id].donators, campigns[_id].donations);

    }

    function getCampignCount() public view returns (Campign[] memory ){
        Campign[] memory allCampigns = new Campign[](campignCount);
        // This line of code is attempting to create a new array of Campign structs in memory, with a length equal to campignCount. The new array is then assigned to the allCampigns variable.

        for (uint i = 0;i<campignCount;i++){
            Campign storage item = campigns[i];
            allCampigns[i] = item;
            // We are frtching that specify campign from the storage and we are populating it straight to our allCampigns array
        }

        return allCampigns;
    }

}