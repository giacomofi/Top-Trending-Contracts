['/**\n', ' *Submitted for verification at Etherscan.io on 2021-03-17\n', '*/\n', '\n', '// SPDX-License-Identifier: GPL-3.0\n', '\n', 'pragma solidity >=0.7.0 <0.8.0;\n', '\n', '/**\n', ' * @title ERC20 interface\n', ' * @dev see https://eips.ethereum.org/EIPS/eip-20\n', ' */\n', 'interface IERC20 {\n', '    function transfer(address to, uint256 value) external returns (bool);\n', '    function approve(address spender, uint256 value) external returns (bool);\n', '    function transferFrom(address from, address to, uint256 value) external returns (bool);\n', '    function totalSupply() external view returns (uint256);\n', '    function balanceOf(address who) external view returns (uint256);\n', '    function allowance(address owner, address spender) external view returns (uint256);\n', '    event Transfer(address indexed from, address indexed to, uint256 value);\n', '    event Approval(address indexed owner, address indexed spender, uint256 value);\n', '}\n', '\n', 'interface IUniswapV2Pair {\n', '    event Approval(address indexed owner, address indexed spender, uint value);\n', '    event Transfer(address indexed from, address indexed to, uint value);\n', '\n', '    function name() external pure returns (string memory);\n', '    function symbol() external pure returns (string memory);\n', '    function decimals() external pure returns (uint8);\n', '    function totalSupply() external view returns (uint);\n', '    function balanceOf(address owner) external view returns (uint);\n', '    function allowance(address owner, address spender) external view returns (uint);\n', '\n', '    function approve(address spender, uint value) external returns (bool);\n', '    function transfer(address to, uint value) external returns (bool);\n', '    function transferFrom(address from, address to, uint value) external returns (bool);\n', '\n', '    function DOMAIN_SEPARATOR() external view returns (bytes32);\n', '    function PERMIT_TYPEHASH() external pure returns (bytes32);\n', '    function nonces(address owner) external view returns (uint);\n', '\n', '    function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;\n', '\n', '    event Mint(address indexed sender, uint amount0, uint amount1);\n', '    event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);\n', '    event Swap(\n', '        address indexed sender,\n', '        uint amount0In,\n', '        uint amount1In,\n', '        uint amount0Out,\n', '        uint amount1Out,\n', '        address indexed to\n', '    );\n', '    event Sync(uint112 reserve0, uint112 reserve1);\n', '\n', '    function MINIMUM_LIQUIDITY() external pure returns (uint);\n', '    function factory() external view returns (address);\n', '    function token0() external view returns (address);\n', '    function token1() external view returns (address);\n', '    function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);\n', '    function price0CumulativeLast() external view returns (uint);\n', '    function price1CumulativeLast() external view returns (uint);\n', '    function kLast() external view returns (uint);\n', '\n', '    function mint(address to) external returns (uint liquidity);\n', '    function burn(address to) external returns (uint amount0, uint amount1);\n', '    function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;\n', '    function skim(address to) external;\n', '    function sync() external;\n', '\n', '    function initialize(address, address) external;\n', '}\n', '\n', '\n', 'contract rewardPool {\n', '    \n', '    IUniswapV2Pair ICAP_wETH;\n', '    IUniswapV2Pair ICAP_DAI;\n', '    IERC20 wETH;\n', '    IERC20 DAI;\n', '\n', '    constructor() {\n', '        ICAP_wETH = IUniswapV2Pair(0x0422edb6E1A5258298cc0366C5f719bbd1Bd85be);\n', '        ICAP_DAI = IUniswapV2Pair(0xcb57A7Eac6AD4BA80E48eDea2cb426D6576ab681);\n', '        wETH = IERC20(0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2);\n', '        DAI = IERC20(0x6B175474E89094C44Da98b954EedeAC495271d0F);\n', '    }\n', '\n', '    function rewardWETHPool(uint256 amountWETH) public {\n', '        wETH.transfer(address(ICAP_wETH), amountWETH);\n', '        ICAP_wETH.sync();\n', '    }\n', '    \n', '    function rewardDAIPool(uint256 amountDAI) public {\n', '        DAI.transfer(address(ICAP_DAI), amountDAI);\n', '        ICAP_DAI.sync();\n', '    }\n', '\n', '}']