['/**\n', ' *Submitted for verification at Etherscan.io on 2021-04-08\n', '*/\n', '\n', '// SPDX-License-Identifier: AGPL-3.0-or-later\n', 'pragma solidity 0.7.4;\n', '\n', 'interface IERC20 {\n', '  function balanceOf(address account) external view returns (uint256);\n', '\n', '  function transfer(address recipient, uint256 amount) external returns (bool);\n', '\n', '  function allowance(address owner, address spender) external view returns (uint256);\n', '\n', '  function approve(address spender, uint256 amount) external returns (bool);\n', '\n', '  event Transfer(address indexed from, address indexed to, uint256 value);\n', '\n', '  event Approval(address indexed owner, address indexed spender, uint256 value);\n', '}\n', '\n', 'interface IUniswapV2Router01 {\n', '    function factory() external pure returns (address);\n', '    function swapExactTokensForTokens(\n', '        uint amountIn,\n', '        uint amountOutMin,\n', '        address[] calldata path,\n', '        address to,\n', '        uint deadline\n', '    ) external returns (uint[] memory amounts);\n', '    function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);\n', '    function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);\n', '    function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);\n', '    function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);\n', '    function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);\n', '}\n', '\n', 'interface IUniswapV2Router02 is IUniswapV2Router01 {\n', '    function swapExactTokensForTokensSupportingFeeOnTransferTokens(\n', '        uint amountIn,\n', '        uint amountOutMin,\n', '        address[] calldata path,\n', '        address to,\n', '        uint deadline\n', '    ) external;\n', '}\n', '\n', 'library SafeMath {\n', '\n', '    function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        uint256 c = a + b;\n', '        require(c >= a, "SafeMath: addition overflow");\n', '\n', '        return c;\n', '    }\n', '\n', '    function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        return sub(a, b, "SafeMath: subtraction overflow");\n', '    }\n', '\n', '    function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {\n', '        require(b <= a, errorMessage);\n', '        uint256 c = a - b;\n', '\n', '        return c;\n', '    }\n', '\n', '    function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        return div(a, b, "SafeMath: division by zero");\n', '    }\n', '\n', '    function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {\n', '        require(b > 0, errorMessage);\n', '        uint256 c = a / b;\n', "        // assert(a == b * c + a % b); // There is no case in which this doesn't hold\n", '\n', '        return c;\n', '    }\n', '}\n', '\n', 'interface StakingDistributor {\n', '    function distribute() external returns ( bool );\n', '}\n', '\n', 'interface IVault {\n', '    function depositReserves( uint _amount ) external returns ( bool );\n', '}\n', '\n', 'contract OlympusSalesLite {\n', '    \n', '    using SafeMath for uint;\n', '    \n', '    address public owner;\n', '\n', '    address public constant SUSHISWAP_ROUTER_ADDRESS = 0xd9e1cE17f2641f24aE83637ab66a2cca9C378B9F;\n', '    IUniswapV2Router02 public sushiswapRouter;\n', '\n', '    uint public OHMToSell; // OHM sold per epoch ( 9 decimals )\n', '    uint public minimumToReceive; // Minimum DAI from sale ( 18 decimals )\n', '    uint public OHMToSellNextEpoch; // Setter to change OHMToSell\n', '\n', '    uint public nextEpochBlock; \n', '    uint public epochBlockLength;\n', '\n', '    address public OHM;\n', '    address public DAI;\n', '    address public stakingDistributor; // Receives new OHM\n', '    address public vault; // Mints new OHM\n', '\n', '    address public DAO; // Receives a share of new OHM\n', '    uint public DAOShare; // % = ( 1 / DAOShare )\n', '\n', '    bool public salesEnabled;\n', '\n', '    constructor( \n', '        address _OHM, \n', '        address _DAI, \n', '        address _DAO,\n', '        address _stakingDistributor, \n', '        address _vault, \n', '        uint _nextEpochBlock,\n', '        uint _epochBlockLength,\n', '        uint _OHMTOSell,\n', '        uint _minimumToReceive,\n', '        uint _DAOShare\n', '    ) {\n', '        owner = msg.sender;\n', '        sushiswapRouter = IUniswapV2Router02( SUSHISWAP_ROUTER_ADDRESS );\n', '        OHM = _OHM;\n', '        DAI = _DAI;\n', '        vault = _vault;\n', '\n', '        OHMToSell = _OHMTOSell;\n', '        OHMToSellNextEpoch = _OHMTOSell;\n', '        minimumToReceive = _minimumToReceive;\n', '\n', '        nextEpochBlock = _nextEpochBlock;\n', '        epochBlockLength = _epochBlockLength;\n', '\n', '        DAO = _DAO;\n', '        DAOShare = _DAOShare;\n', '        stakingDistributor = _stakingDistributor;\n', '    }\n', '\n', '    // Swaps OHM for DAI, then mints new OHM and sends to distributor\n', '    // uint _triggerDistributor - triggers staking distributor if == 1\n', '    function makeSale( uint _triggerDistributor ) external returns ( bool ) {\n', '        require( salesEnabled, "Sales are not enabled" );\n', '        require( block.number >= nextEpochBlock, "Not next epoch" );\n', '\n', '        IERC20(OHM).approve( SUSHISWAP_ROUTER_ADDRESS, OHMToSell );\n', '        sushiswapRouter.swapExactTokensForTokens( // Makes trade on sushi\n', '            OHMToSell, \n', '            minimumToReceive,\n', '            getPathForOHMtoDAI(), \n', '            address(this), \n', '            block.timestamp + 15\n', '        );\n', '        \n', '        uint daiBalance = IERC20(DAI).balanceOf(address(this) );\n', '        IERC20( DAI ).approve( vault, daiBalance );\n', '        IVault( vault ).depositReserves( daiBalance ); // Mint OHM\n', '\n', '        uint OHMToTransfer = IERC20(OHM).balanceOf( address(this) ).sub( OHMToSellNextEpoch );\n', '        uint transferToDAO = OHMToTransfer.div( DAOShare );\n', '\n', '        IERC20(OHM).transfer( stakingDistributor, OHMToTransfer.sub( transferToDAO ) ); // Transfer to staking\n', '        IERC20(OHM).transfer( DAO, transferToDAO ); // Transfer to DAO\n', '\n', '        nextEpochBlock = nextEpochBlock.add( epochBlockLength );\n', '        OHMToSell = OHMToSellNextEpoch;\n', '\n', '        if ( _triggerDistributor == 1 ) { \n', '            StakingDistributor( stakingDistributor ).distribute(); // Distribute epoch rebase\n', '        }\n', '        return true;\n', '    }\n', '\n', '    function getPathForOHMtoDAI() private view returns ( address[] memory ) {\n', '        address[] memory path = new address[](2);\n', '        path[0] = OHM;\n', '        path[1] = DAI;\n', '        \n', '        return path;\n', '    }\n', '\n', '    // Turns sales on or off\n', '    function toggleSales() external returns ( bool ) {\n', '        require( msg.sender == owner, "Only owner" );\n', '        salesEnabled = !salesEnabled;\n', '        return true;\n', '    }\n', '\n', '    // Sets sales rate one epoch ahead\n', '    function setOHMToSell( uint _amount, uint _minimumToReceive ) external returns ( bool ) {\n', '        require( msg.sender == owner, "Only owner" );\n', '        OHMToSellNextEpoch = _amount;\n', '        minimumToReceive = _minimumToReceive;\n', '        return true;\n', '    }\n', '\n', '    // Sets the DAO profit share ( % = 1 / share_ )\n', '    function setDAOShare( uint _share ) external returns ( bool ) {\n', '        require( msg.sender == owner, "Only owner" );\n', '        DAOShare = _share;\n', '        return true;\n', '    }\n', '\n', '    function transferOwnership( address _newOwner ) external returns ( bool ) {\n', '        require( msg.sender == owner, "Only owner" );\n', '        owner = _newOwner;\n', '        return true;\n', '    }\n', '}']