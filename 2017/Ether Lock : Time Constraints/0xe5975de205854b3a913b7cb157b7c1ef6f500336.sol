['pragma solidity ^0.4.13;\n', '\n', 'contract token { \n', '    function transfer(address _to, uint256 _value);\n', '    function balanceOf(address _owner) constant returns (uint256 balance);\n', '}\n', '\n', 'contract stopScamHolder {\n', '    \n', '    token public sharesTokenAddress;\n', '    address public owner;\n', '    uint public endTime = 1510664400;////10 symbols\n', '    uint256 public tokenFree;\n', '\n', 'modifier onlyOwner() {\n', '    require(msg.sender == owner);\n', '    _;\n', '}\n', '\n', 'function stopScamHolder(address _tokenAddress) {\n', '    sharesTokenAddress = token(_tokenAddress);\n', '    owner = msg.sender;\n', '}\n', '\n', 'function tokensBack() onlyOwner public {\n', '    if(now > endTime){\n', '        sharesTokenAddress.transfer(owner, sharesTokenAddress.balanceOf(this));\n', '    }\n', '    tokenFree = sharesTokenAddress.balanceOf(this);\n', '}\t\n', '\n', '}']