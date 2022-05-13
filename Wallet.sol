//SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.5.0 <0.9.0;
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/access/Ownable.sol";


contract Allowance is Ownable{
    mapping(address => uint ) public allowance;

    function addAllowance(address _who, uint _amount) public onlyOwner{
        allowance[_who] = _amount;
    }

    modifier ownerOrAllowed(uint _amount){
        require( owner() == msg.sender || allowance[msg.sender] >= _amount , "You are not allowed");
        _;
    }

    function reduceAllowance(address _to , uint _amount) private{
        allowance[_to] -= _amount; 
    }

}

contract Wallet is Allowance{

    function withdrawMoney(address payable _to , uint _amount) public ownerOrAllowed(_amount){
        require(_amount <= address(this).balance , "Amount should be less than equal to smart contact");
        if(owner() != msg.sender){
            reduceAllowance(_to , _amount);
        }
        _to.transfer(_amount);
        
    }

    receive() external payable {  }

    fallback () external payable{  }

    function getContractBalance() public view returns(uint){
        return address(this).balance;
    }
}