// SPDX-License-Identifier: MIT 
pragma solidity >=0.8.13;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
// import "@openzeppelin/contracts/access/Ownable.sol";



contract Pool {

    // Buy  شراء
    // Sale  بيع
    // Deposit ايداع
    // withdraw  سحب
    // Rate معدل او فائده
    // cost التكلفة
    // purchased تم شرائه
    // balance الرصيد
    // total supply مجموع التزويد
    // approve وافق
    // burn حرق
    // paused متوقف مؤقتا
    
    // decimals=18
    // 1 BNB = 10 ** 18 wei
    // 1 token= 10 ** 18 wei 
    // 0.01 BNB = 0.01 * (10 ** 18)wei= 10 ** 16 wei
    // price token = 1000 tokens => 10 BNB 
    //             = 1000 / 10 = 0.01 BNB
    // price token = 0.01 BNB  = 10 ** 16 wei
    // price token = 7 USD ==> 1 BNB = 700 USD
    // 


   // instance ERC20

   IERC20 public Token;
   address public Owner;

   // Price Tokens
    uint256 public Rate=10**16; // 0.01 BNB
    bool public isSaleActive=true;


    // mapping address Purchased tokens
    mapping(address => uint256) public purchasedTokens;
    address[] purchasedAccounts;
   // events
    event SaleStatusChanged(bool isActive);
    event TokensBuyPurchased(address indexed buyer,uint256 amount,uint256 cost);
    event BalanceWithdraw(address indexed owner,uint256 amount);


    constructor(address _tokenAddress) {
       Owner=msg.sender;
       //set Token in this contract
       Token = IERC20(_tokenAddress);
       Rate=10**16;
    }

    // set Token in this contract
    function setToken(address _tokenAddress) external {
        Token = IERC20(_tokenAddress);
    }



    // change status sale Tokens
    function toggleSaleStatus()external{
        require(msg.sender == Owner, "you are not Owner");
        
        isSaleActive= !isSaleActive;
        emit SaleStatusChanged(isSaleActive);
    }

      // buy Tokens
    function buyTokens()external payable{
        require(msg.value > 0,"Send BNB to buy Tokens");

       require(isSaleActive,"Tokens sale is currently paused");
        // حساب عدد التوكنات التي يمكن شراؤها
        uint256 tokensToBuy= (msg.value / Rate) * 10**18;
        
        // كمية الوكنات التي يملكها العقد
        uint256 contractBalance=Token.balanceOf(address(this));

        require(tokensToBuy > 0,"Not enough BNB sent for any tokens");
        require(tokensToBuy <= contractBalance, "Not enough token in the Contract");

        // تحويل التوكنات الى المشتري والاحتفاظ بالمبلغ المدفوع
        Token.transfer(msg.sender,tokensToBuy);

        //save address and token to buy
        purchasedTokens[msg.sender]+=tokensToBuy;
        uint f=0;
        for(uint256 i=0;i<purchasedAccounts.length;i++){
            if(purchasedAccounts[i]==msg.sender){f=1;break; }
        }
        if(f==1) return ;
        purchasedAccounts.push(msg.sender);

    }


  // get PurchasedTkens
   function getPurchased()view external returns( uint256[] memory,address[] memory){
    uint256 length=purchasedAccounts.length;
    uint256[] memory purchasedValue=new uint256[](length);
    for(uint256 i=0;i<length;i++){
       purchasedValue[i]=purchasedTokens[purchasedAccounts[i]];
    }

    return (purchasedValue,purchasedAccounts);
   }



 // get total balances contract
   function getContractBalances()external view returns(uint256){
    return address(this).balance;
   }



   // get account balance
     function getAccountBalances(address account)external view returns(uint256){
    return Token.balanceOf(account) ;
   }


    function setRate(uint256 _rate)external {
         require(msg.sender == Owner, "you are not Owner");
         require(_rate>0,"is not rate equale Zero");
         Rate=_rate;
    }
    function getRate() view external returns (uint){
        return Rate ; //rate / (10**18) this is 0 , by correct result => (rate * (10**18)) / 10**18 = 0.01
    }


    // deposite
    //ACCOUNT --> CONTRACT
    function deposit(uint _amount) external {
        require(msg.sender == Owner, "you are not Owner");
        
        require(_amount > 0,"The amount is not allowed to be less or aqual to Zero");

        Token.transferFrom(msg.sender, address(this), _amount);
    }
    

    // withdraw
    //CONTRACT --> OWNER ==> balnace this contract
    function withDrawBNB() external {
         require(msg.sender == Owner, "you are not Owner");

        // حساب المبلغ المخزن في هذا العقد
        uint256 balance= address(this).balance;

        require(balance > 0,"No BNB to withdraw");

        // transfer balance to owner
        payable(msg.sender).transfer(balance);
    }
   

    // withdraw
    //CONTRACT -->ANY ACCOUNT
     function withdraw(address recipent,uint256 _amount) external {
            require(msg.sender == Owner, "you are not Owner");
            
            require(_amount > 0,"The amount is not allowed to be less or aqual to Zero");

            // check balance
            Token.transfer(recipent, _amount);
    }





}