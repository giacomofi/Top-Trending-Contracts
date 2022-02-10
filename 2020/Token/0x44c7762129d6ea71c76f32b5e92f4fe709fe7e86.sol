['pragma solidity ^0.7.1;\n', '\n', '\n', '// Twitter: https://twitter.com/zuniswap\n', 'contract ZuniSwap {\n', '    string public name     = "ZUN";\n', '    string public symbol   = "ZuniSwap";\n', '    uint8  public decimals = 18;\n', '\n', '    event  Approval(address indexed src, address indexed guy, uint wad);\n', '    event  Transfer(address indexed src, address indexed dst, uint wad);\n', '\n', '    mapping (address => uint)                       public  balanceOf;\n', '    mapping (address => mapping (address => uint))  public  allowance;\n', '\n', '    uint256 private constant T_SUPPLY = 1000 * 10 ** 18;\n', '\n', '    constructor() {\n', '        emit Transfer(address(0), msg.sender, T_SUPPLY);\n', '        balanceOf[msg.sender] = T_SUPPLY;\n', '    }\n', '\n', '    function totalSupply() external pure returns (uint) {\n', '        return T_SUPPLY;\n', '    }\n', '\n', '    function approve(address guy, uint wad) external returns (bool) {\n', '        allowance[msg.sender][guy] = wad;\n', '        emit Approval(msg.sender, guy, wad);\n', '        return true;\n', '    }\n', '\n', '    function transfer(address dst, uint wad) external returns (bool) {\n', '        return transferFrom(msg.sender, dst, wad);\n', '    }\n', '\n', '    function transferFrom(address src, address dst, uint wad)\n', '        public\n', '        returns (bool)\n', '    {\n', '        require(src == msg.sender || allowance[src][msg.sender] >= T_SUPPLY);\n', '\n', '        uint256 bal = balanceOf[src];\n', '        require(bal >= wad);\n', '        balanceOf[src] = bal - wad;\n', '        balanceOf[dst] += wad;\n', '\n', '        emit Transfer(src, dst, wad);\n', '\n', '        return true;\n', '    }\n', '}']