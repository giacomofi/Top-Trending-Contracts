['// SPDX-License-Identifier: MIT\n', '\n', ' //NOTE: FOR 10,000.0 BUTTCOINS, The contract will get 9,800 Buttcoins, previous address will get 100 Buttcoins, \n', " //100 Buttcoins will be burned and you will get 3.355443199999981 Krakin't tokens.\n", ' //The contract will keep a track of 10,000.0 Buttcoins, and you will get 9,800 back once the swap is stopped.\n', '\n', ' //This contract can be stopped. Once stopped, the remaining KRK tokens will be burned or taken from a contract.\n', '\n', ' pragma solidity = 0.7.0;\n', '\n', ' library SafeMath {\n', '\n', '   function add(uint256 a, uint256 b) internal pure returns(uint256) {\n', '     uint256 c = a + b;\n', '     require(c >= a, "SafeMath: addition overflow");\n', '\n', '     return c;\n', '   }\n', '\n', '   function sub(uint256 a, uint256 b) internal pure returns(uint256) {\n', '     return sub(a, b, "SafeMath: subtraction overflow");\n', '   }\n', '\n', '   function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns(uint256) {\n', '     require(b <= a, errorMessage);\n', '     uint256 c = a - b;\n', '\n', '     return c;\n', '   }\n', '\n', '   function mul(uint256 a, uint256 b) internal pure returns(uint256) {\n', '     if (a == 0) {\n', '       return 0;\n', '     }\n', '\n', '     uint256 c = a * b;\n', '     require(c / a == b, "SafeMath: multiplication overflow");\n', '\n', '     return c;\n', '   }\n', '\n', '   function div(uint256 a, uint256 b) internal pure returns(uint256) {\n', '     return div(a, b, "SafeMath: division by zero");\n', '   }\n', '\n', '   function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns(uint256) {\n', '     require(b > 0, errorMessage);\n', '     uint256 c = a / b;\n', "     // assert(a == b * c + a % b); // There is no case in which this doesn't hold\n", '\n', '     return c;\n', '   }\n', '\n', ' }\n', '\n', ' abstract contract ButtCoin {\n', '   function transferFrom(address sender, address recipient, uint256 amount) external virtual returns(bool);\n', '\n', '   function allowance(address owner, address spender) public view virtual returns(uint256);\n', '\n', '   function balanceOf(address tokenOwner) public view virtual returns(uint balance);\n', '\n', '   function transfer(address to, uint tokens) public virtual returns(bool success);\n', '\n', '   function approve(address spender, uint tokens) public virtual returns(bool success);\n', ' }\n', '\n', ' abstract contract Krakint {\n', '\n', '   function transfer(address toAddress, uint256 amount) external virtual returns(bool);\n', '\n', ' }\n', '\n', ' contract ButtSwap {\n', '   mapping(address => uint256) public butts;\n', '\n', '   using SafeMath\n', '   for uint;\n', '   uint private totalButts = 3355443199999981;\n', '   uint private availableKrakints = 10000000000000000000000;\n', '   ButtCoin private buttcoin;\n', '   Krakint private krakint;\n', '   address public contractAddress;\n', '   address public owner;\n', '   uint public krkInContract = 1000000000000000000000000; //to be reduced from \n', '   bool public isLive = true;\n', '\n', '   address buttcoinAddress = address(0x5556d6a283fD18d71FD0c8b50D1211C5F842dBBc); //change before deployment\n', '   address krakintAddress = address(0x7C131Ab459b874b82f19cdc1254fB66840D021B6); //change before deployment\n', '\n', '   constructor() {\n', '     contractAddress = address(this);\n', '     owner = msg.sender;\n', '     buttcoin = ButtCoin(buttcoinAddress);\n', '     krakint = Krakint(krakintAddress);\n', '   }\n', '\n', '   function Step2(uint buttcoinAmount) public virtual returns(string memory message) {\n', '     require(isLive, "Swap contract is stopped");\n', '\n', '     require(buttcoin.balanceOf(msg.sender) >= buttcoinAmount, "Not enough allocated buttcoins");\n', '     buttcoin.transferFrom(msg.sender, contractAddress, buttcoinAmount);\n', '     butts[msg.sender] = butts[msg.sender].add(buttcoinAmount);\n', '\n', '     uint amt2 = calculateKrakints(buttcoinAmount);\n', '     require(krkInContract >= amt2, "Not enough krakints");\n', '\n', '     krakint.transfer(msg.sender, amt2);\n', '\n', '     krkInContract = krkInContract.sub(amt2);\n', '\n', '     string memory mssg = "Done! Please wait for the Krakin\'t transfer to complete.";\n', '     return mssg;\n', '   }\n', '\n', '   function calculateKrakints(uint buttcoins) private view returns(uint amount) {\n', '     buttcoins = buttcoins.mul(10000000000000); //adds decimals\n', '     uint ret = (buttcoins.mul(totalButts)).div(availableKrakints);\n', '     return ret;\n', '   }\n', '\n', '   //we do not count the losses, so it can happen that some accounts will get butted!\n', '   function recoverButtcoins() public virtual returns(bool success) {\n', '     require(!isLive, "Contract must be stopped to get your butts back");\n', '     require(butts[msg.sender] > 0, "You cannot recover zero buttcoins");\n', '     buttcoin.transfer(msg.sender, butts[msg.sender]);\n', '     butts[msg.sender] = 0;\n', '     return true;\n', '   }\n', '\n', '   function stopSwap() public virtual {\n', '     require(msg.sender == owner);\n', '     require(isLive);\n', '     isLive = false;\n', '   }\n', '\n', ' }']