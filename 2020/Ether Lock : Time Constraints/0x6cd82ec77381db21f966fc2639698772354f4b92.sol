['pragma solidity 0.6.9;\n', '\n', 'library SafeMath {\n', '    function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        uint256 c = a + b;\n', '        require(c >= a, "SafeMath: addition overflow");\n', '\n', '        return c;\n', '    }\n', '\n', '    function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        require(b <= a, "SafeMath: subtraction overflow");\n', '        uint256 c = a - b;\n', '\n', '        return c;\n', '    }\n', '\n', '\n', '    function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        if (a == 0) {\n', '            return 0;\n', '        }\n', '\n', '        uint256 c = a * b;\n', '        require(c / a == b, "SafeMath: multiplication overflow");\n', '\n', '        return c;\n', '    }\n', '\n', '    function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        // Solidity only automatically asserts when dividing by 0\n', '        require(b > 0, "SafeMath: division by zero");\n', '        uint256 c = a / b;\n', "        // assert(a == b * c + a % b); // There is no case in which this doesn't hold\n", '\n', '        return c;\n', '    }\n', '\n', '}\n', '\n', '\n', 'interface IERC20 {\n', '  function totalSupply() external view returns (uint256);\n', '  function balanceOf(address account) external view returns (uint256);\n', '  function transfer(address recipient, uint256 amount) external returns (bool);\n', '  function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);\n', '  function decimals() external view returns (uint8);\n', '}\n', '\n', 'interface IUniswapV2Pair {\n', '  function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);\n', '  function token0() external view returns (address);\n', '  function token1() external view returns (address);\n', '}\n', '\n', 'contract HYDRAStaking {\n', '\n', '    using SafeMath for uint;\n', '\n', '    address private immutable sdcpToken;\n', '    address private immutable v2Pair;\n', '\n', '    uint8 private immutable sdcpDec;\n', '\n', '    uint constant DAY =  60 * 60 * 24; \n', '\n', '    uint constant RATE = 10000;\n', '    uint constant LEAST = 500;\n', '\n', '    address _owner;\n', '    uint public bonus = 0;\n', '\n', '    constructor(address sdcp , address v2) public {\n', '      _owner = msg.sender;\n', '      sdcpToken = sdcp;\n', '      sdcpDec = IERC20(sdcp).decimals();\n', '      v2Pair = v2;\n', '      require(IUniswapV2Pair(v2).token0() == sdcp || IUniswapV2Pair(v2).token1() == sdcp, "E/no sdcp");\n', '    }\n', '\n', '    struct Staking {\n', '      uint amount;\n', '      uint stakeTime;\n', '      uint earnTime;   \n', '    }\n', '\n', '    mapping(address => Staking) V2Stakings;\n', '    mapping(address => Staking) SDCPStakings;\n', '\n', '\n', '    mapping(uint => uint) dayPrices;\n', '\n', '    mapping(uint => bool) raiseOver10;\n', '\n', '    \n', '    function myV2Staking() external view returns (uint, uint, uint ) {\n', '      return (V2Stakings[msg.sender].amount, V2Stakings[msg.sender].stakeTime, myV2Earn());\n', '    }\n', '\n', '    function stakingV2(uint amount) external {\n', '      require(V2Stakings[msg.sender].amount == 0, "E/aleady staking");\n', '      require(IERC20(v2Pair).transferFrom(msg.sender, address(this), amount), "E/transfer error");\n', '      V2Stakings[msg.sender] = Staking(amount, now, now);\n', '    }\n', '\n', '    \n', '    function wdV2(uint amount) external {\n', '      uint stakingToal = V2Stakings[msg.sender].amount;\n', '      uint stakingTime = V2Stakings[msg.sender].stakeTime;\n', '\n', '      require(stakingToal >= amount, "E/not enough");\n', '      require(now >= stakingTime + 2 * DAY, "E/locked");\n', '\n', '     \n', '      wdV2Earn() ;\n', '\n', '      IERC20(v2Pair).transfer(msg.sender, amount);\n', '\n', '     \n', '      if(stakingToal - amount > 0) {\n', '        V2Stakings[msg.sender] = Staking(stakingToal - amount, now, now);\n', '      } else {\n', '        delete V2Stakings[msg.sender];\n', '      }\n', '    }\n', '\n', '    \n', '    function myV2Earn() internal view returns (uint) {\n', '      Staking memory s = V2Stakings[msg.sender];\n', '      if(s.amount == 0) {\n', '        return 0;\n', '      }\n', '\n', '      uint endDay = getDay(now);\n', '      uint startDay = getDay(s.earnTime);\n', '      if(endDay > startDay) {\n', '        uint earnDays = endDay - startDay;\n', '\n', '        uint earns = 0;\n', '        if(earnDays > 0) {\n', '          earns = s.amount.mul(earnDays).mul(RATE).div(10 ** (uint(18).sub(sdcpDec)));\n', '        }\n', '        return earns;\n', '      } \n', '      return 0;\n', '    }\n', '\n', '    function wdV2Earn() public {\n', '      uint earnsTotal = myV2Earn();\n', '      uint fee = earnsTotal * 8 / 100;\n', '      bonus = bonus.add(fee);\n', '\n', '      IERC20(sdcpToken).transfer(msg.sender, earnsTotal.sub(fee));\n', '      V2Stakings[msg.sender].earnTime = now;\n', '    }\n', '\n', '    // ----- for sdcp staking  ------\n', '    function mySDCPStaking() external view returns (uint, uint, uint ) {\n', '      return (SDCPStakings[msg.sender].amount, SDCPStakings[msg.sender].stakeTime, mySDCPEarn());\n', '    }\n', '\n', '    function stakingSDCP(uint amount) external {\n', '      require(amount >= LEAST * 10 ** uint(sdcpDec), "E/not enough");\n', '      require(SDCPStakings[msg.sender].amount == 0, "E/aleady staking");\n', '      require(IERC20(sdcpToken).transferFrom(msg.sender, address(this), amount), "E/transfer error");\n', '      \n', '      SDCPStakings[msg.sender] = Staking(amount, now, now);\n', '    }\n', '\n', '    function wdSDCP(uint amount) external {\n', '      uint stakingToal = SDCPStakings[msg.sender].amount;\n', '      require(stakingToal >= amount, "E/not enough");\n', '\n', '      wdSDCPEarn();\n', '      \n', '      if(stakingToal - amount >= LEAST * 10 ** uint(sdcpDec)) {\n', '        \n', '        uint fee = amount * 8 / 100;\n', '        bonus = bonus.add(fee);\n', '\n', '        IERC20(sdcpToken).transfer(msg.sender, amount.sub(fee));\n', '        SDCPStakings[msg.sender] = Staking(stakingToal - amount, now, now);\n', '      } else {\n', '        \n', '        uint fee = stakingToal * 8 / 100;\n', '        bonus = bonus.add(fee);\n', '\n', '        IERC20(sdcpToken).transfer(msg.sender, stakingToal.sub(fee));\n', '        delete SDCPStakings[msg.sender];\n', '      }\n', '    }\n', '\n', '    \n', '    function mySDCPEarn() internal view returns (uint) {\n', '      Staking memory s = SDCPStakings[msg.sender];\n', '      if(s.amount == 0) {\n', '        return 0;\n', '      }\n', '\n', '      uint earnDays = getEarnDays(s);\n', '      uint earns = 0;\n', '      if(earnDays > 0) {\n', '        earns = s.amount.div(100) * earnDays;\n', '      }\n', '      return earns;\n', '    }\n', '\n', '    \n', '\n', '    function wdSDCPEarn() public {\n', '      uint earnsTotal = mySDCPEarn();\n', '\n', '      uint fee = earnsTotal * 8 / 100;\n', '      bonus = bonus.add(fee);\n', '\n', '      IERC20(sdcpToken).transfer(msg.sender, earnsTotal.sub(fee));\n', '\n', '      SDCPStakings[msg.sender].earnTime = now;\n', '    }\n', '\n', '    \n', '    function getEarnDays(Staking memory s) internal view returns (uint) {\n', '    \n', '      uint startDay = getDay(s.earnTime);\n', '    \n', '      uint endDay = getDay(now);\n', '\n', '    \n', '      uint earnDays = 0;\n', '      while(endDay > startDay) {\n', '        if(raiseOver10[startDay]) {\n', '          earnDays += 1;\n', '        }\n', '        startDay += 1;\n', '      }\n', '      return earnDays;\n', '    }\n', '\n', '    // get 1 sdcp  =  x eth\n', '    function fetchPrice() internal view returns (uint) {\n', '      (uint reserve0, uint reserve1,) = IUniswapV2Pair(v2Pair).getReserves();\n', "      require(reserve0 > 0 && reserve1 > 0, 'E/INSUFFICIENT_LIQUIDITY');\n", '      uint oneSdcp = 10 ** uint(sdcpDec);  \n', '\n', '      if(IUniswapV2Pair(v2Pair).token0() == sdcpToken) {\n', '        return oneSdcp.mul(reserve1) / reserve0;\n', '      } else {\n', '        return oneSdcp.mul(reserve0) / reserve1;\n', '      }\n', '    }\n', '\n', '    \n', '    function getDay(uint ts) internal pure returns (uint) {   \n', '      return ts / DAY;\n', '    }\n', '\n', '    \n', '    function updatePrice() external {\n', '    \n', '      uint d = getDay(now);\n', '    \n', '      uint p = fetchPrice();\n', '\n', '      dayPrices[d] = p;\n', '      \n', '      uint lastPrice = dayPrices[d-1];\n', '      \n', '      if(lastPrice > 0) {\n', '\n', '        if(p > lastPrice.add(lastPrice/10)) {\n', '          raiseOver10[d] = true;\n', '        }\n', '      }\n', '    }\n', '\n', '\n', '    modifier onlyOwner() {\n', '      require(isOwner(), "Ownable: caller is not the owner");\n', '      _;\n', '    }\n', '\n', '    function isOwner() public view returns (bool) {\n', '        return msg.sender == _owner;\n', '    }\n', '\n', '    function owner() public view returns (address) {\n', '      return _owner;\n', '    }\n', '\n', '    function transferOwnership(address newOwner) public onlyOwner {\n', '      _transferOwnership(newOwner);\n', '    }\n', '\n', '    function _transferOwnership(address newOwner) internal {\n', '      require(newOwner != address(0), "Ownable: new owner is the zero address");\n', '      _owner = newOwner;\n', '    }\n', '\n', '    function withdrawSDCP(uint amount) external onlyOwner {\n', '      IERC20(sdcpToken).transfer(msg.sender, amount);\n', '    }\n', '}']