['pragma solidity ^0.4.21;\n', '\n', 'contract ERC20Basic {\n', '    function totalSupply() public view returns (uint256);\n', '    function balanceOf(address who) public view returns (uint256);\n', '    function transfer(address to, uint256 value) public returns (bool);\n', '    event Transfer(address indexed from, address indexed to, uint256 value);\n', '}\n', 'contract ERC20 is ERC20Basic {\n', '    function allowance(address owner, address spender) public view returns (uint256);\n', '    function transferFrom(address from, address to, uint256 value) public returns (bool);\n', '    function approve(address spender, uint256 value) public returns (bool);\n', '    event Approval(address indexed owner, address indexed spender, uint256 value);\n', '}\n', 'library SafeERC20 {\n', '    function safeTransfer(ERC20 token, address to, uint256 value) internal {\n', '        assert(token.transfer(to, value));\n', '    }\n', '    function safeTransferFrom(ERC20 token, address from, address to, uint256 value) internal{\n', '        assert(token.transferFrom(from, to, value));\n', '    }\n', '}\n', '\n', 'library SafeMath {\n', '  function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    uint256 c = a * b;\n', '    assert(a == 0 || c / a == b);\n', '    return c;\n', '  }\n', '\n', '  function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    uint256 c = a / b;\n', '    return c;\n', '  }\n', '\n', '  function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', '\n', '  function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    uint256 c = a + b;\n', '    assert(c >= a);\n', '    return c;\n', '  }\n', '}\n', '\n', 'contract TOSPrivateIncentiveContract {\n', '    using SafeERC20 for ERC20;\n', '    using SafeMath for uint;\n', '    string public constant name = "TOSPrivateIncentiveContract";\n', '    uint[6] public unlockePercentages = [\n', '        15,  //15%\n', '        35,   //20%\n', '        50,   //15%\n', '        65,   //15%\n', '        80,   //15%\n', '        100   //20%\n', '    ];\n', '\n', '    uint256 public unlocked = 0;\n', '    uint256 public totalLockAmount = 0; \n', '\n', '    address public constant beneficiary = 0xbd9d16f47F061D9c6b1C82cb46f33F0aC3dcFB87;\n', '    ERC20 public constant tosToken = ERC20(0xFb5a551374B656C6e39787B1D3A03fEAb7f3a98E);\n', '    uint256 public constant UNLOCKSTART               = 1541347200; //2018/11/5 0:0:0\n', '    uint256 public constant UNLOCKINTERVAL            = 30 days; // 30 days\n', '    \n', '\n', '    function TOSPrivateIncentiveContract() public {}\n', '    function unlock() public {\n', '\n', '        uint256 num = now.sub(UNLOCKSTART).div(UNLOCKINTERVAL);\n', '        if (totalLockAmount == 0) {\n', '            totalLockAmount = tosToken.balanceOf(this);\n', '        }\n', '\n', '        if (num >= unlockePercentages.length.sub(1)) {\n', '            tosToken.safeTransfer(beneficiary, tosToken.balanceOf(this));\n', '            unlocked = 100;\n', '        }\n', '        else {\n', '            uint256 releaseAmount = totalLockAmount.mul(unlockePercentages[num].sub(unlocked)).div(100);\n', '            tosToken.safeTransfer(beneficiary, releaseAmount);\n', '            unlocked = unlockePercentages[num];\n', '        }\n', '    }\n', '}']