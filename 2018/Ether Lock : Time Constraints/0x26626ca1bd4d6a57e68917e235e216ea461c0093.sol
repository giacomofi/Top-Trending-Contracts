['pragma solidity 0.4.23;\n', '\n', 'contract ERC20Interface {\n', '  function transfer(address to, uint256 tokens) public returns (bool success);\n', '}\n', '\n', 'contract DonationWallet {\n', '\n', '  address public owner = msg.sender;\n', '  \n', '  event Deposit(address sender, uint256 amount);\n', '  \n', '  function() payable public {\n', '    // only process transactions with value\n', '    require(msg.value > 0);\n', '    \n', '    // only log donations larger than 1 szabo to prevent spam\n', '    if(msg.value > 1 szabo) {\n', '        emit Deposit(msg.sender, msg.value);        \n', '    }\n', '    \n', '    // transfer donation to contract owner\n', '    address(owner).transfer(msg.value);\n', '  }\n', '  \n', '  // method to withdraw ERC20 tokens sent to this contract\n', '  function transferTokens(address tokenAddress, uint256 tokens) public returns(bool success) {\n', '    require(msg.sender == owner);\n', '    return ERC20Interface(tokenAddress).transfer(owner, tokens);\n', '  }\n', '\n', '}']