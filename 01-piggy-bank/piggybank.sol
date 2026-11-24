// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

//only owner can withdraw
//
contract PiggyBank{

    address payable public owner;
    mapping(address=>uint256 ) public deposits;
    event Deposited(address indexed user, uint256 amount);
    event Withdrawed(address indexed  user, uint256 amount);


    constructor ( ) payable{
        owner = payable(msg.sender);
    }

    modifier onlyOwner() {
        require(msg.sender == owner,"not owner");
        _;
    }

    function deposit() public payable{
        require(msg.value>0,"send some eth");
        deposits[msg.sender] += msg.value;
        emit Deposited(msg.sender, msg.value);
    }

    function withdraw() public onlyOwner{
        uint256 amount = address(this).balance;
        require(amount>0,"not enough to send");
        (bool success, ) = owner.call{value: amount}("");
        require(success, "withdraw failed");
        emit Withdrawed(owner, amount);
    }

    function getbalance() external view returns(uint256){
        return address(this).balance;
    } 


}
