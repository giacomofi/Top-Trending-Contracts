['/**\n', ' *Submitted for verification at Etherscan.io on 2021-04-23\n', '*/\n', '\n', 'pragma solidity 0.6.6;\n', '\n', 'library SafeMath {\n', '    /**\n', '     * @dev Returns the addition of two unsigned integers, reverting on\n', '     * overflow.\n', '     *\n', "     * Counterpart to Solidity's `+` operator.\n", '     *\n', '     * Requirements:\n', '     * - Addition cannot overflow.\n', '     */\n', '    function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        uint256 c = a + b;\n', '        require(c >= a, "SafeMath: addition overflow");\n', '\n', '        return c;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the subtraction of two unsigned integers, reverting on\n', '     * overflow (when the result is negative).\n', '     *\n', "     * Counterpart to Solidity's `-` operator.\n", '     *\n', '     * Requirements:\n', '     * - Subtraction cannot overflow.\n', '     */\n', '    function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        return sub(a, b, "SafeMath: subtraction overflow");\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the subtraction of two unsigned integers, reverting with custom message on\n', '     * overflow (when the result is negative).\n', '     *\n', "     * Counterpart to Solidity's `-` operator.\n", '     *\n', '     * Requirements:\n', '     * - Subtraction cannot overflow.\n', '     */\n', '    function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {\n', '        require(b <= a, errorMessage);\n', '        uint256 c = a - b;\n', '\n', '        return c;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the multiplication of two unsigned integers, reverting on\n', '     * overflow.\n', '     *\n', "     * Counterpart to Solidity's `*` operator.\n", '     *\n', '     * Requirements:\n', '     * - Multiplication cannot overflow.\n', '     */\n', '    function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', "        // Gas optimization: this is cheaper than requiring 'a' not being zero, but the\n", "        // benefit is lost if 'b' is also tested.\n", '        // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522\n', '        if (a == 0) {\n', '            return 0;\n', '        }\n', '\n', '        uint256 c = a * b;\n', '        require(c / a == b, "SafeMath: multiplication overflow");\n', '\n', '        return c;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the integer division of two unsigned integers. Reverts on\n', '     * division by zero. The result is rounded towards zero.\n', '     *\n', "     * Counterpart to Solidity's `/` operator. Note: this function uses a\n", '     * `revert` opcode (which leaves remaining gas untouched) while Solidity\n', '     * uses an invalid opcode to revert (consuming all remaining gas).\n', '     *\n', '     * Requirements:\n', '     * - The divisor cannot be zero.\n', '     */\n', '    function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        return div(a, b, "SafeMath: division by zero");\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the integer division of two unsigned integers. Reverts with custom message on\n', '     * division by zero. The result is rounded towards zero.\n', '     *\n', "     * Counterpart to Solidity's `/` operator. Note: this function uses a\n", '     * `revert` opcode (which leaves remaining gas untouched) while Solidity\n', '     * uses an invalid opcode to revert (consuming all remaining gas).\n', '     *\n', '     * Requirements:\n', '     * - The divisor cannot be zero.\n', '     */\n', '    function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {\n', '        // Solidity only automatically asserts when dividing by 0\n', '        require(b > 0, errorMessage);\n', '        uint256 c = a / b;\n', "        // assert(a == b * c + a % b); // There is no case in which this doesn't hold\n", '\n', '        return c;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),\n', '     * Reverts when dividing by zero.\n', '     *\n', "     * Counterpart to Solidity's `%` operator. This function uses a `revert`\n", '     * opcode (which leaves remaining gas untouched) while Solidity uses an\n', '     * invalid opcode to revert (consuming all remaining gas).\n', '     *\n', '     * Requirements:\n', '     * - The divisor cannot be zero.\n', '     */\n', '    function mod(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        return mod(a, b, "SafeMath: modulo by zero");\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),\n', '     * Reverts with custom message when dividing by zero.\n', '     *\n', "     * Counterpart to Solidity's `%` operator. This function uses a `revert`\n", '     * opcode (which leaves remaining gas untouched) while Solidity uses an\n', '     * invalid opcode to revert (consuming all remaining gas).\n', '     *\n', '     * Requirements:\n', '     * - The divisor cannot be zero.\n', '     */\n', '    function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {\n', '        require(b != 0, errorMessage);\n', '        return a % b;\n', '    }\n', '}\n', '\n', 'interface IToken {\n', '\n', '  function totalSupply() external view returns (uint256);\n', '\n', '  function balanceOf(address account) external view returns (uint256);\n', '\n', '  function name() external view returns (string memory);\n', '\n', '  function symbol() external view returns (string memory);\n', '\n', '  function decimals() external view returns (uint8);\n', '\n', '  function intervalLength() external returns (uint256);\n', '  \n', '  function owner() external view returns (address);\n', '  \n', '  function burn(uint256 _amount) external;\n', '  \n', '  function renounceMinter() external;\n', '  \n', '  function mint(address account, uint256 amount) external returns (bool);\n', '\n', '  function lock(\n', '    address recipient,\n', '    uint256 amount,\n', '    uint256 blocks,\n', '    bool deposit\n', '  ) external returns (bool);\n', '\n', '  function approve(address spender, uint256 amount) external returns (bool);\n', '  \n', '  function transfer(address to, uint256 amount) external returns (bool success);\n', '\n', '}\n', '\n', 'interface IDutchAuction {\n', '  function auctionEnded() external view returns (bool);\n', '\n', '  function finaliseAuction() external;\n', '}\n', '\n', '\n', 'interface IDutchSwapFactory {\n', '  function deployDutchAuction(\n', '    address _token,\n', '    uint256 _tokenSupply,\n', '    uint256 _startDate,\n', '    uint256 _endDate,\n', '    address _paymentCurrency,\n', '    uint256 _startPrice,\n', '    uint256 _minimumPrice,\n', '    address _wallet\n', '  ) external returns (address dutchAuction);\n', '}\n', '\n', 'interface IPriceOracle {\n', '\n', '  function consult(uint256 amountIn) external view returns (uint256 amountOut);\n', '\n', '  function update() external;\n', '}\n', '\n', 'contract AuctionManager {\n', '  using SafeMath for uint256;\n', '\n', '  event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);\n', '\n', '  // used as factor when dealing with %\n', '  uint256 constant ACCURACY = 1e4;\n', '  // when 95% at market price, start selling\n', '  uint256 public sellThreshold;\n', '  // cap auctions at certain amount of $TRDL minted\n', '  uint256 public dilutionBound;\n', '  // stop selling when volume small\n', '  // uint256 public dustThreshold; set at dilutionBound / 52\n', '  // % start_price above estimate, and % min_price below estimate\n', '  uint256 public priceSpan;\n', '  // auction duration\n', '  uint256 public auctionDuration;\n', '\n', '  IToken private strudel;\n', '  IToken private vBtc;\n', '  IToken private gStrudel;\n', '  IPriceOracle private btcPriceOracle;\n', '  IPriceOracle private vBtcPriceOracle;\n', '  IPriceOracle private strudelPriceOracle;\n', '  IDutchSwapFactory private auctionFactory;\n', '\n', '  IDutchAuction public currentAuction;\n', '  mapping(address => uint256) public lockTimeForAuction;\n', '\n', '  constructor(\n', '    address _strudelAddr,\n', '    address _gStrudel,\n', '    address _vBtcAddr,\n', '    address _btcPriceOracle,\n', '    address _vBtcPriceOracle,\n', '    address _strudelPriceOracle,\n', '    address _auctionFactory\n', '  ) public {\n', '    strudel = IToken(_strudelAddr);\n', '    gStrudel = IToken(_gStrudel);\n', '    vBtc = IToken(_vBtcAddr);\n', '    btcPriceOracle = IPriceOracle(_btcPriceOracle);\n', '    vBtcPriceOracle = IPriceOracle(_vBtcPriceOracle);\n', '    strudelPriceOracle = IPriceOracle(_strudelPriceOracle);\n', '    auctionFactory = IDutchSwapFactory(_auctionFactory);\n', '    sellThreshold = 9500; // vBTC @ 95% of BTC price or above\n', '    dilutionBound = 70; // 0.7% of $TRDL total supply\n', '    priceSpan = 2500; // 25%\n', '    auctionDuration = 84600; // ~23,5h\n', '  }\n', '\n', '  function min(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    return a < b ? a : b;\n', '  }\n', '\n', '  function _getDiff(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    if (a > b) {\n', '      return a - b;\n', '    }\n', '    return b - a;\n', '  }\n', '\n', '  function decimals() public view returns (uint8) {\n', '      return gStrudel.decimals();\n', '  }\n', '\n', '  /**\n', '   * @dev See {IERC20-totalSupply}.\n', '   */\n', '  function totalSupply() public view returns (uint256) {\n', '      return gStrudel.totalSupply();\n', '  }\n', '\n', '  /**\n', '   * @dev See {IERC20-balanceOf}.\n', '   */\n', '  function balanceOf(address account) public view returns (uint256) {\n', '      return gStrudel.balanceOf(account);\n', '  }\n', '\n', '  /**\n', '   * @dev Throws if called by any account other than the owner.\n', '   */\n', '  modifier onlyOwner() {\n', '    require(strudel.owner() == msg.sender, "Ownable: caller is not the owner");\n', '    _;\n', '  }\n', '\n', '  function updateOracles() public {\n', '    try btcPriceOracle.update() {\n', '      // do nothing\n', '    } catch Error(string memory) {\n', '      // do nothing\n', '    } catch (bytes memory) {\n', '      // do nothing\n', '    }\n', '    try vBtcPriceOracle.update() {\n', '      // do nothing\n', '    } catch Error(string memory) {\n', '      // do nothing\n', '    } catch (bytes memory) {\n', '      // do nothing\n', '    }\n', '    try strudelPriceOracle.update() {\n', '      // do nothing\n', '    } catch Error(string memory) {\n', '      // do nothing\n', '    } catch (bytes memory) {\n', '      // do nothing\n', '    }\n', '  }\n', '\n', '  function rotateAuctions() external {\n', '    if (address(currentAuction) != address(0)) {\n', '      require(currentAuction.auctionEnded(), "previous auction hasn\'t ended");\n', '      try currentAuction.finaliseAuction() {\n', '        // do nothing\n', '      } catch Error(string memory) {\n', '        // do nothing\n', '      } catch (bytes memory) {\n', '        // do nothing\n', '      }\n', '      uint256 studelReserves = strudel.balanceOf(address(this));\n', '      if (studelReserves > 0) {\n', '        strudel.burn(studelReserves);\n', '      }\n', '    }\n', '\n', '    updateOracles();\n', '\n', '    // get prices\n', '    uint256 btcPriceInEth = btcPriceOracle.consult(1e18);\n', '    uint256 vBtcPriceInEth = vBtcPriceOracle.consult(1e18);\n', '    uint256 strudelPriceInEth = strudelPriceOracle.consult(1e18);\n', '\n', '    // measure outstanding supply\n', '    uint256 vBtcOutstandingSupply = vBtc.totalSupply();\n', '    uint256 strudelSupply = strudel.totalSupply();\n', '    uint256 vBtcAmount = vBtc.balanceOf(address(this));\n', '    vBtcOutstandingSupply -= vBtcAmount;\n', '\n', '    // calculate vBTC supply imbalance in ETH\n', '    uint256 imbalance = _getDiff(btcPriceInEth, vBtcPriceInEth).mul(vBtcOutstandingSupply);\n', '\n', '    uint256 cap = strudelSupply.mul(dilutionBound).mul(strudelPriceInEth).div(ACCURACY);\n', '    // cap by dillution bound\n', '    imbalance = min(\n', '      cap,\n', '      imbalance\n', '    );\n', '\n', '    // pause if imbalance below dust threshold\n', '    if (imbalance.div(strudelPriceInEth) < strudelSupply.mul(dilutionBound).div(52).div(ACCURACY)) {\n', '      // pause auctions\n', '      currentAuction = IDutchAuction(address(0));\n', '      return;\n', '    }\n', '\n', '    // determine what kind of auction we want\n', '    uint256 priceRelation = btcPriceInEth.mul(ACCURACY).div(vBtcPriceInEth);\n', '    if (priceRelation < ACCURACY.mul(ACCURACY).div(sellThreshold)) {\n', '      // cap vBtcAmount by imbalance in vBTC\n', '      vBtcAmount = min(vBtcAmount, imbalance.div(vBtcPriceInEth));\n', '      // calculate vBTC price\n', '      imbalance = vBtcPriceInEth.mul(1e18).div(strudelPriceInEth);\n', '      // auction off some vBTC\n', '      vBtc.approve(address(auctionFactory), vBtcAmount);\n', '      currentAuction = IDutchAuction(\n', '        auctionFactory.deployDutchAuction(\n', '          address(vBtc),\n', '          vBtcAmount,\n', '          now,\n', '          now + auctionDuration,\n', '          address(strudel),\n', '          imbalance.mul(ACCURACY.add(priceSpan)).div(ACCURACY), // startPrice\n', '          imbalance.mul(ACCURACY.sub(priceSpan)).div(ACCURACY), // minPrice\n', '          address(this)\n', '        )\n', '      );\n', '    } else {\n', '\n', '      // calculate price in vBTC\n', '      vBtcAmount = strudelPriceInEth.mul(1e18).div(vBtcPriceInEth);\n', '      // auction off some $TRDL\n', '      currentAuction = IDutchAuction(\n', '        auctionFactory.deployDutchAuction(\n', '          address(this),\n', '          imbalance.div(strudelPriceInEth), // calculate imbalance in $TRDL\n', '          now,\n', '          now + auctionDuration,\n', '          address(vBtc),\n', '          vBtcAmount.mul(ACCURACY.add(priceSpan)).div(ACCURACY), // startPrice\n', '          vBtcAmount.mul(ACCURACY.sub(priceSpan)).div(ACCURACY), // minPrice\n', '          address(this)\n', '        )\n', '      );\n', '\n', '      // if imbalance >= dillution bound, use max lock (52 weeks)\n', '      // if imbalance < dillution bound, lock shorter\n', '      lockTimeForAuction[address(currentAuction)] = gStrudel.intervalLength().mul(52).mul(imbalance).div(cap);\n', '    }\n', '  }\n', '\n', '  function setSellThreshold(uint256 _threshold) external onlyOwner {\n', '    require(_threshold >= 6000, "threshold below 60% minimum");\n', '    require(_threshold <= 12000, "threshold above 120% maximum");\n', '    sellThreshold = _threshold;\n', '  }\n', '\n', '  function setDulutionBound(uint256 _dilutionBound) external onlyOwner {\n', '    require(_dilutionBound <= 1000, "dilution bound above 10% max value");\n', '    dilutionBound = _dilutionBound;\n', '  }\n', '\n', '  function setPriceSpan(uint256 _priceSpan) external onlyOwner {\n', '    require(_priceSpan > 1000, "price span should have at least 10%");\n', '    require(_priceSpan < ACCURACY, "price span larger accuracy");\n', '    priceSpan = _priceSpan;\n', '  }\n', '\n', '  function setAuctionDuration(uint256 _auctionDuration) external onlyOwner {\n', '    require(_auctionDuration >= 3600, "auctions should run at laest for 1 hour");\n', '    require(_auctionDuration <= 604800, "auction duration should be less than week");\n', '    auctionDuration = _auctionDuration;\n', '  }\n', '\n', '  function renounceMinter() external onlyOwner {\n', '    strudel.renounceMinter();\n', '  }\n', '\n', '  function swipe(address tokenAddr) external onlyOwner {\n', '    IToken token = IToken(tokenAddr);\n', '    token.transfer(strudel.owner(), token.balanceOf(address(this)));\n', '  }\n', '\n', '  // In deployDutchAuction, approve and transferFrom are called\n', '  // In initDutchAuction, transferFrom is called again\n', '  // In DutchAuction, transfer is called to either payout, or return money to AuctionManager\n', '\n', '  function transferFrom(address, address, uint256) public pure returns (bool) {\n', '    return true;\n', '  }\n', '\n', '  function approve(address, uint256) public pure returns (bool) {\n', '    return true;\n', '  }\n', '\n', '  function transfer(address to, uint256 amount) public returns (bool success) {\n', '    // require sender is our Auction\n', '    address auction = msg.sender;\n', '    require(lockTimeForAuction[auction] > 0, "Caller is not our auction");\n', '\n', '    // if recipient is AuctionManager, it means we are doing a refund -> do nothing\n', '    if (to == address(this)) return true;\n', '\n', '    uint256 blocks = lockTimeForAuction[auction];\n', '    strudel.mint(address(this), amount);\n', '    strudel.approve(address(gStrudel), amount);\n', '    gStrudel.lock(to, amount, blocks, false);\n', '    return true;\n', '  }\n', '}']