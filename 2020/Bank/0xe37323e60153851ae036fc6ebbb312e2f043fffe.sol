['// SPDX-License-Identifier: MIT\n', '\n', 'pragma solidity ^0.6.12;\n', '\n', '\n', 'interface IERC20 {\n', '    function totalSupply() external view returns (uint256);\n', '\n', '    function balanceOf(address account) external view returns (uint256);\n', '\n', '    function transfer(address recipient, uint256 amount)\n', '    external\n', '    returns (bool);\n', '\n', '    function allowance(address owner, address spender)\n', '    external\n', '    view\n', '    returns (uint256);\n', '\n', '    function approve(address spender, uint256 amount) external returns (bool);\n', '\n', '    function transferFrom(\n', '        address sender,\n', '        address recipient,\n', '        uint256 amount\n', '    ) external returns (bool);\n', '\n', '    event Transfer(address indexed from, address indexed to, uint256 value);\n', '    event Approval(\n', '        address indexed owner,\n', '        address indexed spender,\n', '        uint256 value\n', '    );\n', '}\n', 'interface IUniswapV2Pair is IERC20 {\n', '    function token0() external view returns (address);\n', '    function token1() external view returns (address);\n', '    function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);\n', '}\n', 'interface MasterChef {\n', '    function userInfo(uint256, address)\n', '    external\n', '    view\n', '    returns (uint256, uint256);\n', '}\n', '\n', 'contract YaxisVoteProxy {\n', '    // ETH/YAX token\n', '    IUniswapV2Pair public constant yaxEthUniswapV2Pair = IUniswapV2Pair(\n', '        0x1107B6081231d7F256269aD014bF92E041cb08df\n', '    );\n', '    // YAX token\n', '    IERC20 public constant yax = IERC20(\n', '        0xb1dC9124c395c1e97773ab855d66E879f053A289\n', '    );\n', '\n', '    // YaxisChef contract\n', '    MasterChef public constant chef = MasterChef(\n', '        0xC330E7e73717cd13fb6bA068Ee871584Cf8A194F\n', '    );\n', '\n', '    // Pool 6 is the ETH/YAX pool\n', '    uint256 public constant pool = uint256(6);\n', '\n', "    // Using 9 decimals as we're square rooting the votes\n", '    function decimals() external pure returns (uint8) {\n', '        return uint8(9);\n', '    }\n', '\n', '    function name() external pure returns (string memory) {\n', '        return "YAXIS Vote Power";\n', '    }\n', '\n', '    function symbol() external pure returns (string memory) {\n', '        return "YAX VP";\n', '    }\n', '\n', '    function totalSupply() external view returns (uint256) {\n', '        (uint256 _yaxAmount,, ) = yaxEthUniswapV2Pair.getReserves();\n', '        return sqrt(yax.totalSupply()) + sqrt((2 * _yaxAmount * yaxEthUniswapV2Pair.balanceOf(address(chef))) / yaxEthUniswapV2Pair.totalSupply());\n', '    }\n', '    function balanceOf(address _voter) external view returns (uint256) {\n', '        (uint256 _stakeAmount, ) = chef.userInfo(pool, _voter);\n', '        (uint256 _yaxAmount,, ) = yaxEthUniswapV2Pair.getReserves();\n', '        return sqrt(yax.balanceOf(_voter)) + sqrt((2 * _yaxAmount * _stakeAmount) / yaxEthUniswapV2Pair.totalSupply());\n', '    }\n', '\n', '    function sqrt(uint256 x) public pure returns (uint256 y) {\n', '        uint256 z = (x + 1) / 2;\n', '        y = x;\n', '        while (z < y) {\n', '            y = z;\n', '            z = (x / z + z) / 2;\n', '        }\n', '    }\n', '\n', '    constructor() public {}\n', '}']