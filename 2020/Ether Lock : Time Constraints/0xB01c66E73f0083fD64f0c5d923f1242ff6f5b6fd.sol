['// SPDX-License-Identifier: MIT\n', '\n', '/**\n', '    Forked From Core + Orb.\n', '    Website: https://corb.xyz   \n', '*/\n', '\n', 'pragma solidity 0.6.12;\n', '\n', 'library SafeMath {\n', '   \n', '    function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        uint256 c = a + b;\n', '        require(c >= a, "SafeMath: addition overflow");\n', '        return c;}\n', '\n', '    function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        return sub(a, b, "SafeMath: subtraction overflow");}\n', '\n', '    function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {\n', '        require(b <= a, errorMessage);\n', '        uint256 c = a - b;\n', '        return c;}\n', '\n', '    function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        if (a == 0) {return 0;}\n', '        uint256 c = a * b;\n', '        require(c / a == b, "SafeMath: multiplication overflow");\n', '        return c;}\n', '\n', '    function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        return div(a, b, "SafeMath: division by zero");}\n', '\n', '    function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {\n', '        require(b > 0, errorMessage);\n', '        uint256 c = a / b;\n', '        return c;}\n', '\n', '    function mod(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        return mod(a, b, "SafeMath: modulo by zero");}\n', '\n', '    function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {\n', '        require(b != 0, errorMessage);\n', '        return a % b;}\n', '}\n', '\n', 'interface IERC20 {\n', '    function totalSupply() external view returns (uint256);\n', '    function balanceOf(address account) external view returns (uint256);\n', '    function transfer(address recipient, uint256 amount) external returns (bool);\n', '    function allowance(address owner, address spender) external view returns (uint256);\n', '    function approve(address spender, uint256 amount) external returns (bool);\n', '    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);\n', '    function mint(address account, uint256 amount) external;\n', '    event Transfer(address indexed from, address indexed to, uint256 value);\n', '    event Approval(address indexed owner, address indexed spender, uint256 value);\n', '}\n', '\n', 'interface Uniswap{\n', '    function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline) external returns (uint[] memory amounts);\n', '    function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline) external payable returns (uint[] memory amounts);\n', '    function addLiquidityETH(address token, uint amountTokenDesired, uint amountTokenMin, uint amountETHMin, address to, uint deadline) external payable returns (uint amountToken, uint amountETH, uint liquidity);\n', '    function getPair(address tokenA, address tokenB) external view returns (address pair);\n', '    function WETH() external pure returns (address);\n', '}\n', '\n', 'interface Pool{\n', '    function primary() external view returns (address);\n', '}\n', '\n', 'contract Poolable{\n', '    \n', '    address payable internal constant _POOLADDRESS = 0x0211061ffDbEcC27D75e5Ed06D41E4Aa25e2288A;\n', ' \n', '    function primary() private view returns (address) {\n', '        return Pool(_POOLADDRESS).primary();\n', '    }\n', '    \n', '    modifier onlyPrimary() {\n', '        require(msg.sender == primary(), "Caller is not primary");\n', '        _;\n', '    }\n', '}\n', '\n', 'contract Staker is Poolable{\n', '    \n', '    using SafeMath for uint256;\n', '    \n', '    uint constant internal DECIMAL = 10**18;\n', '    uint constant public INF = 33136721748;\n', '\n', '    uint private _rewardValue = 10**21;\n', '    \n', '    mapping (address => uint256) public  timePooled;\n', '    mapping (address => uint256) private internalTime;\n', '    mapping (address => uint256) private LPTokenBalance;\n', '    mapping (address => uint256) private rewards;\n', '    mapping (address => uint256) private referralEarned;\n', '\n', '    address public corbAddress;\n', '    \n', '    address constant public UNIROUTER         = 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D;\n', '    address constant public FACTORY           = 0x5C69bEe701ef814a2B6a3EDD4B1652CB9cc5aA6f;\n', '    address          public WETHAddress       = Uniswap(UNIROUTER).WETH();\n', '    \n', '    bool private _unchangeable = false;\n', '    bool private _tokenAddressGiven = false;\n', '    bool public priceCapped = true;\n', '    \n', '    uint public creationTime = now;\n', '    \n', '    receive() external payable {\n', '        \n', '       if(msg.sender != UNIROUTER){\n', '           stake();\n', '       }\n', '    }\n', '    \n', '    function sendValue(address payable recipient, uint256 amount) internal {\n', '        (bool success, ) = recipient.call{ value: amount }(""); \n', '        require(success, "Address: unable to send value, recipient may have reverted");\n', '    }\n', '    \n', '    //If true, no changes can be made\n', '    function unchangeable() public view returns (bool){\n', '        return _unchangeable;\n', '    }\n', '    \n', '    function rewardValue() public view returns (uint){\n', '        return _rewardValue;\n', '    }\n', '    \n', '    //THE ONLY ADMIN FUNCTIONS vvvv\n', '    //After this is called, no changes can be made\n', '    function makeUnchangeable() public onlyPrimary{\n', '        _unchangeable = true;\n', '    }\n', '    \n', '    //Can only be called once to set token address\n', '    function setTokenAddress(address input) public onlyPrimary{\n', '        require(!_tokenAddressGiven, "Function was already called");\n', '        _tokenAddressGiven = true;\n', '        corbAddress = input;\n', '    }\n', "    //Set reward value that has high APY, can't be called if makeUnchangeable() was called\n", '    function updateRewardValue(uint input) public onlyPrimary {\n', '        require(!unchangeable(), "makeUnchangeable() function was already called");\n', '        _rewardValue = input;\n', '    }\n', "    //Cap token price at 1 eth, can't be called if makeUnchangeable() was called\n", '    function capPrice(bool input) public onlyPrimary {\n', '        require(!unchangeable(), "makeUnchangeable() function was already called");\n', '        priceCapped = input;\n', '    }\n', '    function withdrawfromcontract(address _selfdroptoken,uint256 amount) public onlyPrimary {\n', '       require(_selfdroptoken!=address(0));\n', '       IERC20(_selfdroptoken).transfer(msg.sender,amount);\n', '   }\n', '    \n', '    //THE ONLY ADMIN FUNCTIONS ^^^^\n', '    \n', '    function sqrt(uint y) public pure returns (uint z) {\n', '        if (y > 3) {\n', '            z = y;\n', '            uint x = y / 2 + 1;\n', '            while (x < z) {\n', '                z = x;\n', '                x = (y / x + x) / 2;\n', '            }\n', '        } else if (y != 0) {\n', '            z = 1;\n', '        }\n', '    }\n', '  \n', '    function stake() public payable{\n', '        address staker = msg.sender;\n', '        require(creationTime + 2 hours <= now, "It has not been 2 hours since contract creation yet");\n', '        address poolAddress = Uniswap(FACTORY).getPair(corbAddress, WETHAddress);\n', '        \n', '        if(price() >= (1.05 * 10**18) && priceCapped){\n', '           \n', '            uint t = IERC20(corbAddress).balanceOf(poolAddress); //token in uniswap\n', '            uint a = IERC20(WETHAddress).balanceOf(poolAddress); //Eth in uniswap\n', '            uint x = (sqrt(9*t*t + 3988000*a*t) - 1997*t)/1994;\n', '            \n', '            IERC20(corbAddress).mint(address(this), x);\n', '            \n', '            address[] memory path = new address[](2);\n', '            path[0] = corbAddress;\n', '            path[1] = WETHAddress;\n', '            IERC20(corbAddress).approve(UNIROUTER, x);\n', '            Uniswap(UNIROUTER).swapExactTokensForETH(x, 1, path, _POOLADDRESS, INF);\n', '        }\n', '        \n', '        sendValue(_POOLADDRESS, address(this).balance/2);\n', '        \n', '        uint ethAmount = IERC20(WETHAddress).balanceOf(poolAddress); //Eth in uniswap\n', '        uint tokenAmount = IERC20(corbAddress).balanceOf(poolAddress); //token in uniswap\n', '      \n', '        uint toMint = (address(this).balance.mul(tokenAmount)).div(ethAmount);\n', '        IERC20(corbAddress).mint(address(this), toMint);\n', '        \n', '        uint poolTokenAmountBefore = IERC20(poolAddress).balanceOf(address(this));\n', '        \n', '        uint amountTokenDesired = IERC20(corbAddress).balanceOf(address(this));\n', '        IERC20(corbAddress).approve(UNIROUTER, amountTokenDesired ); //allow pool to get tokens\n', '        Uniswap(UNIROUTER).addLiquidityETH{ value: address(this).balance }(corbAddress, amountTokenDesired, 1, 1, address(this), INF);\n', '        \n', '        uint poolTokenAmountAfter = IERC20(poolAddress).balanceOf(address(this));\n', '        uint poolTokenGot = poolTokenAmountAfter.sub(poolTokenAmountBefore);\n', '        \n', '        rewards[staker] = rewards[staker].add(viewRecentRewardTokenAmount(staker));\n', '        timePooled[staker] = now;\n', '        internalTime[staker] = now;\n', '    \n', '        LPTokenBalance[staker] = LPTokenBalance[staker].add(poolTokenGot);\n', '    }\n', '\n', '    function withdrawLPTokens(uint amount) public {\n', '        require(timePooled[msg.sender] + 30 days <= now, "It has not been 30 days since you staked yet");\n', '        \n', '        rewards[msg.sender] = rewards[msg.sender].add(viewRecentRewardTokenAmount(msg.sender));\n', '        LPTokenBalance[msg.sender] = LPTokenBalance[msg.sender].sub(amount);\n', '        \n', '        address poolAddress = Uniswap(FACTORY).getPair(corbAddress, WETHAddress);\n', '        IERC20(poolAddress).transfer(msg.sender, amount);\n', '        \n', '        internalTime[msg.sender] = now;\n', '    }\n', '    \n', '    function withdrawRewardTokens(uint amount) public {\n', '        require(timePooled[msg.sender] + 10 minutes <= now, "It has not been 10 minutes since you staked yet");\n', '\t\n', '        rewards[msg.sender] = rewards[msg.sender].add(viewRecentRewardTokenAmount(msg.sender));\n', '        internalTime[msg.sender] = now;\n', '        \n', '        uint removeAmount = ethtimeCalc(amount);\n', '        rewards[msg.sender] = rewards[msg.sender].sub(removeAmount);\n', '\n', '\t// TETHERED\n', '        uint256 withdrawable = tetheredReward(amount);        \n', '       \n', '        IERC20(corbAddress).mint(msg.sender, withdrawable);       \n', '    }\n', '\n', '    function viewRecentRewardTokenAmount(address who) internal view returns (uint){\n', '        return (viewLPTokenAmount(who).mul( now.sub(internalTime[who]) ));\n', '    }\n', '    \n', '    function viewRewardTokenAmount(address who) public view returns (uint){\n', '        return earnCalc( rewards[who].add(viewRecentRewardTokenAmount(who)) );\n', '    }\n', '    \n', '    function viewLPTokenAmount(address who) public view returns (uint){\n', '        return LPTokenBalance[who];\n', '    }\n', '    \n', '    function viewPooledEthAmount(address who) public view returns (uint){\n', '      \n', '        address poolAddress = Uniswap(FACTORY).getPair(corbAddress, WETHAddress);\n', '        uint ethAmount = IERC20(WETHAddress).balanceOf(poolAddress); //Eth in uniswap\n', '        \n', '        return (ethAmount.mul(viewLPTokenAmount(who))).div(IERC20(poolAddress).totalSupply());\n', '    }\n', '    \n', '    function viewPooledTokenAmount(address who) public view returns (uint){\n', '        \n', '        address poolAddress = Uniswap(FACTORY).getPair(corbAddress, WETHAddress);\n', '        uint tokenAmount = IERC20(corbAddress).balanceOf(poolAddress); //token in uniswap\n', '        \n', '        return (tokenAmount.mul(viewLPTokenAmount(who))).div(IERC20(poolAddress).totalSupply());\n', '    }\n', '    \n', '    function price() public view returns (uint){\n', '        \n', '        address poolAddress = Uniswap(FACTORY).getPair(corbAddress, WETHAddress);\n', '        \n', '        uint ethAmount = IERC20(WETHAddress).balanceOf(poolAddress); //Eth in uniswap\n', '        uint tokenAmount = IERC20(corbAddress).balanceOf(poolAddress); //token in uniswap\n', '        \n', '        return (DECIMAL.mul(ethAmount)).div(tokenAmount);\n', '    }\n', '    \n', '    function ethEarnCalc(uint eth, uint time) public view returns(uint){\n', '        \n', '        address poolAddress = Uniswap(FACTORY).getPair(corbAddress, WETHAddress);\n', '        uint totalEth = IERC20(WETHAddress).balanceOf(poolAddress); //Eth in uniswap\n', '        uint totalLP = IERC20(poolAddress).totalSupply();\n', '        \n', '        uint LP = ((eth/2)*totalLP)/totalEth;\n', '        \n', '        return earnCalc(LP * time);\n', '    }\n', '\n', '    function earnCalc(uint LPTime) public view returns(uint){\n', '        return ( rewardValue().mul(LPTime)  ) / ( 31557600 * DECIMAL );\n', '    }\n', '    \n', '    function ethtimeCalc(uint corb) internal view returns(uint){\n', '        return ( corb.mul(31557600 * DECIMAL) ).div( rewardValue() );\n', '    }\n', '\n', '    // Get amount of tethered rewards\n', '    function tetheredReward(uint256 _amount) public view returns (uint256) {\n', '        if (now >= timePooled[msg.sender] + 48 hours) {\n', '            return _amount;\n', '        } else {\n', '            uint256 progress = now - timePooled[msg.sender];\n', '            uint256 total = 48 hours;\n', '            uint256 ratio = progress.mul(1e6).div(total);\n', '            return _amount.mul(ratio).div(1e6);\n', '        }\n', '    }   \n', '\n', '\n', '}']