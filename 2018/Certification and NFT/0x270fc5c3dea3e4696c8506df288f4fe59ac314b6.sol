['pragma solidity ^0.4.19;\n', '\n', 'contract ERC223Interface {\n', '    uint public totalSupply;\n', '    function balanceOf(address who) constant returns (uint);\n', '    function transfer(address to, uint value) public returns (bool success);\n', '    function transfer(address to, uint value, bytes data) public returns (bool success);\n', '    event Transfer(address indexed from, address indexed to, uint value, bytes data);\n', '}\n', '\n', 'contract ReferralContract {\n', '\n', '  address public referral;\n', '  address public referrer;\n', '  address public owner;\n', '  ERC223Interface public we_token;\n', '\n', '  modifier onlyOwner() {\n', '    require(msg.sender == owner);\n', '    _;\n', '  }\n', '\n', '  function ReferralContract(address tokenAddress, address referralAddr, address referrerAddr) {\n', '    owner = msg.sender;\n', '    we_token = ERC223Interface(tokenAddress);\n', '    referral = referralAddr;\n', '    referrer = referrerAddr;\n', '  }\n', '\n', '  function transferOwnership(address newOwner) public onlyOwner {\n', '    if (newOwner != address(0)) {\n', '      owner = newOwner;\n', '    }\n', '  }\n', '\n', '  function changeReferral(address newReferral) onlyOwner {\n', '    referral = newReferral;\n', '  }\n', '\n', '  function changeReferrer(address newReferrer) onlyOwner {\n', '    referrer = newReferrer;\n', '  }\n', '\n', '  function safeMul(uint a, uint b) internal returns (uint) {\n', '    uint c = a * b;\n', '    assert(a == 0 || c / a == b);\n', '    return c;\n', '  }\n', '\n', '  function safeDiv(uint a, uint b) internal returns (uint) {\n', '    assert(b > 0);\n', '    uint c = a / b;\n', '    assert(a == b * c + a % b);\n', '    return c;\n', '  }\n', '\n', '  function tokenFallback(address from, uint value, bytes data) {\n', '     we_token.transfer(referrer, safeDiv(safeMul(value, 25), 100));\n', '     we_token.transfer(referral, safeDiv(safeMul(value, 75), 100));\n', '  }\n', '}']