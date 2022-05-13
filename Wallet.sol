//SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.5.0 <0.9.0;
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/access/Ownable.sol";

contract wallet is Ownable{

    mapping(address => uint ) public allowance;

    function addAllowance(address _who, uint _amount) public onlyOwner{
        allowance[_who] = _amount;

    }

    modifier ownerOrAllowed(uint _amount){
        require(_owner == msg.sender || allowance[msg.sender] > _amount , "You are not allowed");
        _;

    }

    function withdrawMoney(address payable _to , uint _amount) public onlyOwner{
        _to.transfer(_amount);
    }

    receive() external payable {  }

    fallback () external payable{

    }
    function getMoney() public view returns(uint){
        return address(this).balance;
    }
}