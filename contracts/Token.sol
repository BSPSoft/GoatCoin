// SPDX-License-Identifier: MIT
pragma solidity >=0.8.13;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract Token is ERC20 {

  address public Owner;
    constructor () ERC20("BSP Coin","BSPA"){
        Owner=msg.sender;
       _mint(msg.sender,100 * 10 ** decimals());
    }



    // mthod create Tokens
    function mintTokens(uint256 totalSupply) external {
        require(msg.sender==Owner,"this is not Owner");
        require(totalSupply > 0,"It is not allowed for the TotalSupply to be Zero");
        
       _mint(msg.sender,totalSupply * 10 ** decimals());
    }

   // get your balances
     function getYourBalance() external view returns(uint256) {
        return balanceOf(msg.sender);
    }

    // burn Tokens from account 
   function burnTokens(address account,uint256 amount)external {
      require(msg.sender == Owner, "you are not Owner");

      require(amount > 0,"The amount is not allowed to be less or aqual to Zero");

       uint256 contractBalance= balanceOf(Owner) / (10**18);
       require(contractBalance < amount,"Not enough token in the Contract"); 
      _burn(account,amount); 
   }

}