['pragma solidity ^0.4.24;\n', '\n', 'interface IERC20 {\n', '    function transfer(address to, uint256 value) external returns (bool);\n', '\n', '    function approve(address spender, uint256 value) external returns (bool);\n', '\n', '    function transferFrom(address from, address to, uint256 value) external returns (bool);\n', '\n', '    function totalSupply() external view returns (uint256);\n', '\n', '    function balanceOf(address who) external view returns (uint256);\n', '\n', '    function allowance(address owner, address spender) external view returns (uint256);\n', '\n', '    event Transfer(address indexed from, address indexed to, uint256 value);\n', '\n', '    event Approval(address indexed owner, address indexed spender, uint256 value);\n', '}\n', '\n', '\n', '    \n', 'contract MultiSig is IERC20 {\n', '    address private addrA;\n', '    address private addrB;\n', '    address private addrToken;\n', '\n', '    struct Permit {\n', '        bool addrAYes;\n', '        bool addrBYes;\n', '    }\n', '    \n', '    mapping (address => mapping (uint => Permit)) private permits;\n', '    \n', '     event Transfer(address indexed from, address indexed to, uint256 value);\n', '\n', '    event Approval(address indexed owner, address indexed spender, uint256 value);\n', '    \n', '    uint public totalSupply = 10*10**26;\n', '    uint8 constant public decimals = 18;\n', '    string constant public name = "MutiSigPTN";\n', '    string constant public symbol = "MPTN";\n', '\n', ' function approve(address spender, uint256 value) external returns (bool){\n', '     return false;\n', ' }\n', '\n', '    function transferFrom(address from, address to, uint256 value) external returns (bool){\n', '        return false;\n', '    }\n', '\n', '    function totalSupply() external view returns (uint256){\n', '          IERC20 token = IERC20(addrToken);\n', '          return token.totalSupply();\n', '    }\n', '\n', '\n', '    function allowance(address owner, address spender) external view returns (uint256){\n', '        return 0;\n', '    }\n', '    \n', '    constructor(address a, address b, address tokenAddress) public{\n', '        addrA = a;\n', '        addrB = b;\n', '        addrToken = tokenAddress;\n', '    }\n', '    function getAddrs() public view returns(address, address,address) {\n', '      return (addrA, addrB,addrToken);\n', '    }\n', '    function  transfer(address to,  uint amount)  public returns (bool){\n', '        IERC20 token = IERC20(addrToken);\n', '        require(token.balanceOf(this) >= amount);\n', '\n', '        if (msg.sender == addrA) {\n', '            permits[to][amount].addrAYes = true;\n', '        } else if (msg.sender == addrB) {\n', '            permits[to][amount].addrBYes = true;\n', '        } else {\n', '            require(false);\n', '        }\n', '\n', '        if (permits[to][amount].addrAYes == true && permits[to][amount].addrBYes == true) {\n', '            token.transfer(to, amount);\n', '            permits[to][amount].addrAYes = false;\n', '            permits[to][amount].addrBYes = false;\n', '        }\n', '        emit Transfer(msg.sender, to, amount);\n', '        return true;\n', '    }\n', '    function balanceOf(address _owner) public view returns (uint) {\n', '        IERC20 token = IERC20(addrToken);\n', '        if (_owner==addrA || _owner==addrB){\n', '            return token.balanceOf(this);\n', '        }\n', '        return 0;\n', '    }\n', '}']