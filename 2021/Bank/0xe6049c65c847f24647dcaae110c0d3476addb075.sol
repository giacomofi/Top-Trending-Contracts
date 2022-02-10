['pragma solidity ^0.5.16;\n', '\n', 'import "./TalhaToken.sol";\n', '\n', 'contract TalhaTokenSale {\n', '    address payable auctioneer; \n', '\n', '    uint256 public tokenPrice;\n', '    uint256 public tokensSold;\n', '    TalhaToken public tokenContract;\n', '\n', '    event Sell(address _buyer, uint256 _amount);\n', '\n', '    constructor(TalhaToken _tokenContract, uint256 _tokenPrice) public {\n', '    \tauctioneer = msg.sender;\n', '    \ttokenContract = _tokenContract;\n', '    \ttokenPrice = _tokenPrice;\n', '    }\n', '\n', '    //Taken from DS-Math. [https://github.com/dapphub/ds-math/blob/master/src/math.sol]\n', '    function multiply(uint x, uint y) internal pure returns (uint z) {\n', '    \trequire(y == 0 || (z = x * y) / y == x);\n', '    }\n', '\n', '    function buyTokens(uint256 _numberOfTokens) public payable {\n', '    \trequire(msg.value == multiply(_numberOfTokens, tokenPrice));\n', '    \trequire(tokenContract.balanceOf(address(this)) >= _numberOfTokens);\n', '    \trequire(tokenContract.transfer(msg.sender, _numberOfTokens));\n', '\n', '    \ttokensSold += _numberOfTokens;\n', '\n', '    \temit Sell(msg.sender, _numberOfTokens);\n', '    }\n', '\n', '    function endSale() public {\n', '    \trequire(msg.sender == auctioneer);\n', '    \trequire(tokenContract.transfer(auctioneer, tokenContract.balanceOf(address(this))));\n', '\n', '    \tauctioneer.transfer(address(this).balance);\n', '    }\n', '}']