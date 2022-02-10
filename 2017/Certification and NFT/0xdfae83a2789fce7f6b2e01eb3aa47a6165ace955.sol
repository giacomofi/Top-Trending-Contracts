['pragma solidity ^0.4.13;\n', 'library SafeMath {    \n', '  function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    uint256 c = a * b;\n', '    assert(a == 0 || c / a == b);\n', '    return c;\n', '  }\n', '  function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    uint256 c = a / b;\n', '    return c;\n', '  } \n', '  function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  } \n', '  function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    uint256 c = a + b;\n', '    assert(c >= a);\n', '    return c;\n', '  }  \n', '}\n', '\n', 'contract ERC20Basic {\n', '  uint256 public totalSupply;\n', '  function balanceOf(address who) public constant returns (uint256);\n', '  function transfer(address to, uint256 value) public returns (bool);\n', '  event Transfer(address indexed from, address indexed to, uint256 value);\n', '}\n', '\n', 'contract ERC20 is ERC20Basic {\n', '  function allowance(address owner, address spender) public constant returns (uint256);\n', '  function transferFrom(address from, address to, uint256 value) public returns (bool);\n', '  function approve(address spender, uint256 value) public returns (bool);\n', '  event Approval(address indexed owner, address indexed spender, uint256 value);\n', '}\n', '\n', 'contract BasicToken is ERC20Basic {\n', '  \n', '  using SafeMath for uint256;\n', '  bool public teamStakesFrozen = true;\n', '  mapping(address => uint256) balances;\n', '  address public owner;\n', '  \n', '  function BasicToken() public {\n', '    owner = msg.sender;\n', '  }\n', '  \n', '  modifier notFrozen() {\n', '    require(msg.sender != owner || (msg.sender == owner && !teamStakesFrozen));\n', '    _;\n', '  }\n', '\n', '  /**\n', '  * @dev transfer token for a specified address\n', '  * @param _to The address to transfer to.\n', '  * @param _value The amount to be transferred.\n', '  */\n', '  function transfer(address _to, uint256 _value) public notFrozen returns (bool) {\n', '    require(_to != address(0));\n', '    require(_value <= balances[msg.sender]);\n', '    // SafeMath.sub will throw if there is not enough balance.\n', '    balances[msg.sender] = balances[msg.sender].sub(_value);\n', '    balances[_to] = balances[_to].add(_value);\n', '    Transfer(msg.sender, _to, _value);\n', '    return true;\n', '  }\n', '\n', '  /**\n', '  * @dev Gets the balance of the specified address.\n', '  * @param _owner The address to query the the balance of.\n', '  * @return An uint256 representing the amount owned by the passed address.\n', '  */\n', '  function balanceOf(address _owner) public constant returns (uint256 balance) {\n', '    return balances[_owner];\n', '  }\n', '}\n', '\n', 'contract StandardToken is ERC20, BasicToken {\n', '  mapping (address => mapping (address => uint256)) internal allowed;\n', '  /**\n', '   * @dev Transfer tokens from one address to another\n', '   * @param _from address The address which you want to send tokens from\n', '   * @param _to address The address which you want to transfer to\n', '   * @param _value uint256 the amount of tokens to be transferred\n', '   */\n', '  function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {\n', '    require(_to != address(0));\n', '    require(_value <= balances[_from]);\n', '    require(_value <= allowed[_from][msg.sender]);\n', '    balances[_from] = balances[_from].sub(_value);\n', '    balances[_to] = balances[_to].add(_value);\n', '    allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);\n', '    Transfer(_from, _to, _value);\n', '    return true;\n', '  }\n', '\n', '  /**\n', '   * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.\n', '   *\n', '   * Beware that changing an allowance with this method brings the risk that someone may use both the old\n', '   * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this\n', "   * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:\n", '   * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729\n', '   * @param _spender The address which will spend the funds.\n', '   * @param _value The amount of tokens to be spent.\n', '   */\n', '  function approve(address _spender, uint256 _value) public notFrozen returns (bool) {\n', '    allowed[msg.sender][_spender] = _value;\n', '    Approval(msg.sender, _spender, _value);\n', '    return true;\n', '  }\n', '\n', '  /**\n', '   * @dev Function to check the amount of tokens that an owner allowed to a spender.\n', '   * @param _owner address The address which owns the funds.\n', '   * @param _spender address The address which will spend the funds.\n', '   * @return A uint256 specifying the amount of tokens still available for the spender.\n', '   */\n', '  function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {\n', '    return allowed[_owner][_spender];\n', '  }\n', '\n', '  /**\n', '   * approve should be called when allowed[_spender] == 0. To increment\n', '   * allowed value is better to use this function to avoid 2 calls (and wait until\n', '   * the first transaction is mined)\n', '   * From MonolithDAO Token.sol\n', '   */\n', '  function increaseApproval (address _spender, uint _addedValue) public notFrozen returns (bool success) {\n', '    allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);\n', '    Approval(msg.sender, _spender, allowed[msg.sender][_spender]);\n', '    return true;\n', '  }\n', '\n', '  function decreaseApproval (address _spender, uint _subtractedValue) public returns (bool success) {\n', '    uint oldValue = allowed[msg.sender][_spender];\n', '    if (_subtractedValue > oldValue) {\n', '      allowed[msg.sender][_spender] = 0;\n', '    } else {\n', '      allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);\n', '    }\n', '    Approval(msg.sender, _spender, allowed[msg.sender][_spender]);\n', '    return true;\n', '  }\n', '}\n', '\n', 'contract RI is StandardToken {\n', '  string public constant name = "Fundaria Stake";\n', '  string public constant symbol = "RI";\n', '  uint8 public constant decimals = 0;\n', '}\n', '\n', 'contract Sale is RI {\n', '\n', '    using SafeMath for uint;\n', '\n', '/********** \n', ' * Common *\n', ' **********/\n', '\n', '    // THIS IS KEY VARIABLE AND DEFINED ACCORDING TO VALUE OF PLANNED COSTS ON THE PAGE https://business.fundaria.com\n', '    uint public poolCapUSD = 1002750;\n', '    // USD per 1 ether, added 10% aproximatelly to secure from wrong low price. We need add 10% of Stakes to supply to cover such price.\n', '    uint public usdPerEther = 360;\n', '    uint public supplyCap; // Current total supply cap according to lastStakePriceUSCents and poolCapUSD \n', '    uint public businessPlannedPeriodDuration = 365 days; // total period planned for business activity\n', '    uint public businessPlannedPeriodEndTimestamp;\n', '    uint public teamCap; // team Stakes capacity\n', '    uint8 public teamShare = 45; // share for team\n', '    uint public distributedTeamStakes; // distributed Stakes to team   \n', '    uint public contractCreatedTimestamp; // when this contract was created  \n', '    address public pool = 0x335C415D7897B2cb2a2562079400Fb6eDf54a7ab; // initial pool wallet address    \n', '\n', '/********** \n', ' * Bounty *\n', ' **********/\n', ' \n', '    uint public distributedBountyStakes; // bounty advisors Stakes distributed total    \n', '    uint public bountyCap; // bounty advisors Stakes capacity    \n', '    uint8 public bountyShare = 7; // share for bounty    \n', '    \n', '/*********** \n', ' * Sale *\n', ' ***********/\n', '    // data to store invested wei value & Stakes for Investor\n', '    struct saleData {\n', '      uint stakes; // how many Stakes where recieved by this Investor total\n', '      uint invested; // how much wei this Investor invested total\n', '      uint bonusStakes; // how many bonus Stakes where recieved by this Investor\n', '      uint guideReward; // Investment Guide reward amount\n', '      address guide; // address of Investment Guide\n', '    }\n', '    mapping (address=>saleData) public saleStat; // invested value + Stakes data for every Investor        \n', '    uint public saleStartTimestamp = 1511546400; // 1511546400 regular Stakes sale start date            \n', '    uint public saleEndTimestamp = 1513965600; // 1513965600\n', '    uint public distributedSaleStakes; // distributed stakes to all Investors\n', '    uint public totalInvested; //how many invested total\n', '    uint public totalWithdrawn; //how many withdrawn total\n', '    uint public saleCap; // regular sale Stakes capacity   \n', '    uint8 public saleShare = 45; // share for regular sale\n', '    uint public lastStakePriceUSCents; // Stake price in U.S. cents is determined according to current timestamp (the further - the higher price)    \n', '    uint[] public targetPrice;    \n', '    bool public priceIsFrozen = false; // stop increasing the price temporary (in case of low demand. Can be called only after saleEndTimestamp)       \n', '    \n', '/************************************ \n', ' * Bonus Stakes & Investment Guides *\n', ' ************************************/    \n', '    // data to store Investment Guide reward\n', '    struct guideData {\n', '      bool registered; // is this Investment Guide registered\n', '      uint accumulatedPotentialReward; // how many reward wei are potentially available\n', '      uint withdrawnReward; // how much reward wei where withdrawn by this Investment Guide already\n', '    }\n', '    mapping (address=>guideData) public guidesStat; // mapping of Investment Guides datas    \n', '    uint public bonusCap; // max amount of bonus Stakes availabe\n', '    uint public distributedBonusStakes; // how many bonus Stakes are already distributed\n', '    uint public bonusShare = 3; // share of bonus Stakes in supplyCap\n', '    uint8 public guideInvestmentAttractedShareToPay = 10; // reward for the Investment Guide\n', '\n', '/*\n', '  WANT TO EARN ON STAKES SALE ?\n', '  BECOME INVESTMENT GUIDE AND RECIEVE 10% OF ATTRACTED INVESTMENT !\n', '  INTRODUCE YOURSELF ON FUNDARIA.COM@GMAIL.COM & GIVE YOUR WALLET ADDRESS\n', '*/\n', '    \n', '/************* \n', ' * Promotion *\n', ' *************/\n', '    \n', '    uint public maxAmountForSalePromotion = 30 ether; // How many we can use for promotion of sale\n', '    uint public withdrawnAmountForSalePromotion;    \n', '\n', '/********************************************* \n', ' * To Pool transfers & Investment withdrawal *\n', ' *********************************************/\n', '\n', '    uint8 public financePeriodsCount = 12; // How many finance periods in planned period\n', '    uint[] public financePeriodsTimestamps; // Supportive array for searching current finance period\n', '    uint public transferedToPool; // how much wei transfered to pool already\n', '\n', '/* EVENTS */\n', '\n', '    event StakesSale(address to, uint weiInvested, uint stakesRecieved, uint teamStakesRecieved, uint stake_price_us_cents);\n', '    event BountyDistributed(address to, uint bountyStakes);\n', '    event TransferedToPool(uint weiAmount, uint8 currentFinancialPeriodNo);\n', '    event InvestmentWithdrawn(address to, uint withdrawnWeiAmount, uint stakesBurned, uint8 remainedFullFinancialPeriods);\n', '    event UsdPerEtherChanged(uint oldUsdPerEther, uint newUsdPerEther);\n', '    event BonusDistributed(address to, uint bonusStakes, address guide, uint accumulatedPotentialReward);\n', '    event PoolCapChanged(uint oldCapUSD, uint newCapUSD);\n', '    event RegisterGuide(address investmentGuide);\n', '    event TargetPriceChanged(uint8 N, uint oldTargetPrice, uint newTargetPrice);\n', '    \n', '    modifier onlyOwner() {\n', '      require(msg.sender==owner);\n', '      _;\n', '    }\n', '  /**\n', '   * @dev Determine duration of finance period, fill array with finance periods timestamps,\n', '   *      set businessPlannedPeriodEndTimestamp and contractCreatedTimestamp,    \n', '   */      \n', '    function Sale() public {     \n', '      uint financePeriodDuration = businessPlannedPeriodDuration/financePeriodsCount; // quantity of seconds in chosen finance period\n', '      // making array with timestamps of every finance period end date\n', '      for(uint8 i=0; i<financePeriodsCount; i++) {\n', '        financePeriodsTimestamps.push(saleEndTimestamp+financePeriodDuration*(i+1));  \n', '      }\n', '      businessPlannedPeriodEndTimestamp = saleEndTimestamp+businessPlannedPeriodDuration; \n', '      contractCreatedTimestamp = now;\n', '      targetPrice.push(1); // Initial Stake price mark in U.S. cents (1 cent = $0.01)  \n', '      targetPrice.push(10); // price mark at the sale period start timestamp      \n', '      targetPrice.push(100); // price mark at the sale period end timestamp       \n', '      targetPrice.push(1000); // price mark at hte end of business planned period          \n', '    }\n', '  /**\n', '   * @dev How many investment remained? Maximum investment is poolCapUSD\n', '   * @return remainingInvestment in wei   \n', '   */     \n', '    function remainingInvestment() public view returns(uint) {\n', '      return poolCapUSD.div(usdPerEther).mul(1 ether).sub(totalInvested);  \n', '    }\n', '  /**\n', '   * @dev Dynamically set caps\n', '   */       \n', '    function setCaps() internal {\n', '      // remaining Stakes are determined only from remainingInvestment\n', '      saleCap = distributedSaleStakes+stakeForWei(remainingInvestment()); // max available Stakes for sale including already distributed\n', '      supplyCap = saleCap.mul(100).div(saleShare); // max available Stakes for supplying\n', '      teamCap = supplyCap.mul(teamShare).div(100); // max available team Stakes\n', '      bonusCap = supplyCap.mul(bonusShare).div(100); // max available Stakes for bonus\n', '      bountyCap = supplyCap.sub(saleCap).sub(teamCap).sub(bonusCap); // max available Stakes for bounty        \n', '    }\n', '  /**\n', '   * @dev Dynamically set the price of Stake in USD cents, which depends on current timestamp (price grows with time)\n', '   */       \n', '    function setStakePriceUSCents() internal {\n', '        uint targetPriceFrom;\n', '        uint targetPriceTo;\n', '        uint startTimestamp;\n', '        uint endTimestamp;\n', '      // set price for pre sale period      \n', '      if(now < saleStartTimestamp) {\n', '        targetPriceFrom = targetPrice[0];\n', '        targetPriceTo = targetPrice[1];\n', '        startTimestamp = contractCreatedTimestamp;\n', '        endTimestamp = saleStartTimestamp;        \n', '      // set price for sale period\n', '      } else if(now >= saleStartTimestamp && now < saleEndTimestamp) {\n', '        targetPriceFrom = targetPrice[1];\n', '        targetPriceTo = targetPrice[2];\n', '        startTimestamp = saleStartTimestamp;\n', '        endTimestamp = saleEndTimestamp;    \n', '      // set price for post sale period\n', '      } else if(now >= saleEndTimestamp && now < businessPlannedPeriodEndTimestamp) {\n', '        targetPriceFrom = targetPrice[2];\n', '        targetPriceTo = targetPrice[3];\n', '        startTimestamp = saleEndTimestamp;\n', '        endTimestamp = businessPlannedPeriodEndTimestamp;    \n', '      }     \n', '      lastStakePriceUSCents = targetPriceFrom + ((now-startTimestamp)*(targetPriceTo-targetPriceFrom))/(endTimestamp-startTimestamp);       \n', '    }  \n', '  /**\n', '   * @dev Recieve wei and process Stakes sale\n', '   */    \n', '    function() payable public {\n', '      require(msg.sender != address(0));\n', '      require(msg.value > 0); // process only requests with wei\n', '      require(now < businessPlannedPeriodEndTimestamp); // no later then at the end of planned period\n', '      processSale();       \n', '    }\n', '  /**\n', '   * @dev Process Stakes sale\n', '   */       \n', '    function processSale() internal {\n', '      if(!priceIsFrozen) { // refresh price only if price is not frozen\n', '        setStakePriceUSCents();\n', '      }\n', '      setCaps();    \n', '\n', '        uint teamStakes; // Stakes for the team according to teamShare\n', '        uint saleStakes; // Stakes for the Sale\n', '        uint weiInvested; // weiInvested now by this Investor\n', '        uint trySaleStakes = stakeForWei(msg.value); // try to get this quantity of Stakes\n', '\n', '      if(trySaleStakes > 1) {\n', '        uint tryDistribute = distributedSaleStakes+trySaleStakes; // try to distribute this tryStakes        \n', '        if(tryDistribute <= saleCap) { // saleCap not reached\n', '          saleStakes = trySaleStakes; // all tryStakes can be sold\n', '          weiInvested = msg.value; // all current wei are accepted                    \n', '        } else {\n', '          saleStakes = saleCap-distributedSaleStakes; // only remnant of Stakes are available\n', '          weiInvested = weiForStake(saleStakes); // wei for available remnant of Stakes \n', '        }\n', '        teamStakes = (saleStakes*teamShare).div(saleShare); // part of Stakes for a team        \n', '        if(saleStakes > 0) {          \n', '          balances[owner] += teamStakes; // rewarding team according to teamShare\n', '          totalSupply += teamStakes; // supplying team Stakes\n', '          distributedTeamStakes += teamStakes; // saving distributed team Stakes \n', '          saleSupply(msg.sender, saleStakes, weiInvested, teamStakes); // process saleSupply\n', '          if(saleStat[msg.sender].guide != address(0)) { // we have Investment Guide to reward and distribute bonus Stakes\n', '            distributeBonusStakes(msg.sender, saleStakes, weiInvested);  \n', '          }          \n', '        }        \n', '        if(tryDistribute > saleCap) {\n', '          msg.sender.transfer(msg.value-weiInvested); // return remnant\n', '        }        \n', '      } else {\n', '        msg.sender.transfer(msg.value); // return incorrect wei\n', '      }\n', '    }\n', '  /**\n', '   * @dev Transfer Stakes from owner balance to buyer balance & saving data to saleStat storage\n', '   * @param _to is address of buyer \n', '   * @param _stakes is quantity of Stakes transfered \n', '   * @param _wei is value invested        \n', '   */ \n', '    function saleSupply(address _to, uint _stakes, uint _wei, uint team_stakes) internal {\n', '      require(_stakes > 0);   \n', '      balances[_to] = balances[_to].add(_stakes); // to\n', '      totalSupply = totalSupply.add(_stakes);\n', '      distributedSaleStakes = distributedSaleStakes.add(_stakes);\n', '      totalInvested = totalInvested.add(_wei); // adding to total investment\n', '      // saving stat\n', '      saleStat[_to].stakes = saleStat[_to].stakes.add(_stakes); // stating Stakes bought       \n', '      saleStat[_to].invested = saleStat[_to].invested.add(_wei); // stating wei invested\n', '      StakesSale(_to, _wei, _stakes, team_stakes, lastStakePriceUSCents);\n', '    }      \n', '  /**\n', '   * @dev Set new owner\n', '   * @param new_owner new owner  \n', '   */    \n', '    function setNewOwner(address new_owner) public onlyOwner {\n', '      owner = new_owner; \n', '    }\n', '  /**\n', '   * @dev Set new ether price in USD. Should be changed when price grow-fall 5%-10%\n', '   * @param new_usd_per_ether new price  \n', '   */    \n', '    function setUsdPerEther(uint new_usd_per_ether) public onlyOwner {\n', '      UsdPerEtherChanged(usdPerEther, new_usd_per_ether);\n', '      usdPerEther = new_usd_per_ether; \n', '    }\n', '  /**\n', '   * @dev Set address of wallet where investment will be transfered for further using in business transactions\n', '   * @param _pool new address of the Pool   \n', '   */         \n', '    function setPoolAddress(address _pool) public onlyOwner {\n', '      pool = _pool;  \n', '    }\n', '  /**\n', '   * @dev Change Pool capacity in USD\n', '   * @param new_pool_cap_usd new Pool cap in $   \n', '   */    \n', '    function setPoolCapUSD(uint new_pool_cap_usd) public onlyOwner {\n', '      PoolCapChanged(poolCapUSD, new_pool_cap_usd);\n', '      poolCapUSD = new_pool_cap_usd; \n', '    }\n', '  /**\n', '   * @dev Register Investment Guide\n', '   * @param investment_guide address of Investment Guide   \n', '   */     \n', '    function registerGuide(address investment_guide) public onlyOwner {\n', '      guidesStat[investment_guide].registered = true;\n', '      RegisterGuide(investment_guide);\n', '    }\n', '  /**\n', '   * @dev Stop increasing price dynamically. Set it as static temporary. \n', '   */   \n', '    function freezePrice() public onlyOwner {\n', '      priceIsFrozen = true; \n', '    }\n', '  /**\n', '   * @dev Continue increasing price dynamically (the standard, usual algorithm).\n', '   */       \n', '    function unfreezePrice() public onlyOwner {\n', '      priceIsFrozen = false; // this means that price is unfrozen  \n', '    }\n', '  /**\n', '   * @dev Ability to tune dynamic price changing with time.\n', '   */       \n', '    function setTargetPrice(uint8 n, uint stake_price_us_cents) public onlyOwner {\n', '      TargetPriceChanged(n, targetPrice[n], stake_price_us_cents);\n', '      targetPrice[n] = stake_price_us_cents;\n', '    }  \n', '  /**\n', '   * @dev Get and set address of Investment Guide and distribute bonus Stakes and Guide reward\n', '   * @param key address of Investment Guide   \n', '   */     \n', '    function getBonusStakesPermanently(address key) public {\n', '      require(guidesStat[key].registered);\n', '      require(saleStat[msg.sender].guide == address(0)); // Investment Guide is not applied yet for this Investor\n', '      saleStat[msg.sender].guide = key; // apply Guide \n', '      if(saleStat[msg.sender].invested > 0) { // we have invested value, process distribution of bonus Stakes and rewarding a Guide     \n', '        distributeBonusStakes(msg.sender, saleStat[msg.sender].stakes, saleStat[msg.sender].invested);\n', '      }\n', '    }\n', '  /**\n', '   * @dev Distribute bonus Stakes to Investor according to bonusShare\n', '   * @param _to to which Investor to distribute\n', '   * @param added_stakes how many Stakes are added by this Investor    \n', '   * @param added_wei how much wei are invested by this Investor \n', '   * @return wei quantity        \n', '   */       \n', '    function distributeBonusStakes(address _to, uint added_stakes, uint added_wei) internal {\n', '      uint added_bonus_stakes = (added_stakes*((bonusShare*100).div(saleShare)))/100; // how many bonus Stakes to add\n', '      require(distributedBonusStakes+added_bonus_stakes <= bonusCap); // check is bonus cap is not overflowed\n', '      uint added_potential_reward = (added_wei*guideInvestmentAttractedShareToPay)/100; // reward for the Guide\n', '      guidesStat[saleStat[_to].guide].accumulatedPotentialReward += added_potential_reward; // save reward for the Guide\n', '      saleStat[_to].guideReward += added_potential_reward; // add guideReward wei value for stat\n', '      saleStat[_to].bonusStakes += added_bonus_stakes; // add bonusStakes for stat    \n', '      balances[_to] += added_bonus_stakes; // transfer bonus Stakes\n', '      distributedBonusStakes += added_bonus_stakes; // save bonus Stakes distribution\n', '      totalSupply += added_bonus_stakes; // increase totalSupply\n', '      BonusDistributed(_to, added_bonus_stakes, saleStat[_to].guide, added_potential_reward);          \n', '    }\n', '  /**\n', '   * @dev Show how much wei can withdraw Investment Guide\n', '   * @param _guide address of registered guide \n', '   * @return wei quantity        \n', '   */     \n', '    function guideRewardToWithdraw(address _guide) public view returns(uint) {\n', '      uint8 current_finance_period = 0;\n', '      for(uint8 i=0; i < financePeriodsCount; i++) {\n', '        current_finance_period = i+1;\n', '        if(now<financePeriodsTimestamps[i]) {          \n', '          break;\n', '        }\n', '      }\n', '      // reward to withdraw depends on current finance period and do not include potentially withdaw amount of investment\n', '      return (guidesStat[_guide].accumulatedPotentialReward*current_finance_period)/financePeriodsCount - guidesStat[_guide].withdrawnReward;  \n', '    }  \n', '  /**\n', '   * @dev Show share of Stakes on some address related to full supply capacity\n', '   * @param my_address my or someone address\n', '   * @return share of Stakes in % (floored to less number. If less then 1, null is showed)        \n', '   */      \n', '    function myStakesSharePercent(address my_address) public view returns(uint) {\n', '      return (balances[my_address]*100)/supplyCap;\n', '    }\n', '  \n', '  /*\n', '    weiForStake & stakeForWei functions sometimes show not correct translated value from dapp interface (view) \n', '    because lastStakePriceUSCents sometimes temporary outdated (in view mode)\n', "    but it doesn't mean that execution itself is not correct  \n", '  */  \n', '  \n', '  /**\n', '   * @dev Translate wei to Stakes\n', '   * @param input_wei is wei to translate into stakes, \n', '   * @return Stakes quantity        \n', '   */ \n', '    function stakeForWei(uint input_wei) public view returns(uint) {\n', '      return ((input_wei*usdPerEther*100)/1 ether)/lastStakePriceUSCents;    \n', '    }  \n', '  /**\n', '   * @dev Translate Stakes to wei\n', '   * @param input_stake is stakes to translate into wei\n', '   * @return wei quantity        \n', '   */ \n', '    function weiForStake(uint input_stake) public view returns(uint) {\n', '      return (input_stake*lastStakePriceUSCents*1 ether)/(usdPerEther*100);    \n', '    } \n', '  /**\n', '   * @dev Transfer wei from this contract to pool wallet partially only, \n', '   *      1) for funding promotion of Stakes sale   \n', '   *      2) according to share (finance_periods_last + current_finance_period) / business_planned_period\n', '   */    \n', '    function transferToPool() public onlyOwner {      \n', '      uint available; // available funds for transfering to pool    \n', '      uint amountToTransfer; // amount to transfer to pool\n', '      // promotional funds\n', '      if(now < saleEndTimestamp) {\n', '        require(withdrawnAmountForSalePromotion < maxAmountForSalePromotion); // withdrawn not maximum promotional funds\n', '        available = totalInvested/financePeriodsCount; // avaialbe only part of total value of total invested funds        \n', '        // current contract balance + witdrawn promo funds is less or equal to max promo funds\n', '        if(available+withdrawnAmountForSalePromotion <= maxAmountForSalePromotion) {\n', '          withdrawnAmountForSalePromotion += available;\n', '          transferedToPool += available;\n', '          amountToTransfer = available;         \n', '        } else {\n', '          // contract balance + witdrawn promo funds more then maximum promotional funds \n', '          amountToTransfer = maxAmountForSalePromotion-withdrawnAmountForSalePromotion;\n', '          withdrawnAmountForSalePromotion = maxAmountForSalePromotion;\n', '          transferedToPool = maxAmountForSalePromotion;\n', '        }\n', '        pool.transfer(amountToTransfer);\n', '        TransferedToPool(amountToTransfer, 0);             \n', '      } else {\n', '        // search end timestamp of current financial period\n', '        for(uint8 i=0; i < financePeriodsCount; i++) {\n', '          // found end timestamp of current financial period OR now is later then business planned end date (transfer wei remnant)\n', '          if(now < financePeriodsTimestamps[i] || (i == financePeriodsCount-1 && now > financePeriodsTimestamps[i])) {   \n', '            available = ((i+1)*(totalInvested+totalWithdrawn))/financePeriodsCount; // avaialbe only part of total value of total invested funds\n', '            // not all available funds are transfered at the moment\n', '            if(available > transferedToPool) {\n', '              amountToTransfer = available-transferedToPool;\n', '              if(amountToTransfer > this.balance) {\n', '                amountToTransfer = this.balance;  \n', '              }\n', '              transferedToPool += amountToTransfer;\n', '              pool.transfer(amountToTransfer);                           \n', '              TransferedToPool(amountToTransfer, i+1);\n', '            }\n', '            break;    \n', '          }\n', '        }\n', '      }      \n', '    }  \n', '  /**\n', '   * @dev Investor can withdraw part of his/her investment.\n', '   *      A size of this part depends on how many financial periods last and how many remained.\n', '   *      Investor gives back all stakes which he/she got for his/her investment.     \n', '   */       \n', '    function withdrawInvestment() public {\n', '      require(saleStat[msg.sender].stakes > 0);\n', '      require(balances[msg.sender] >= saleStat[msg.sender].stakes+saleStat[msg.sender].bonusStakes); // Investor has needed stakes to return\n', '      require(now > saleEndTimestamp); // do not able to withdraw investment before end of regular sale period\n', '      uint remained; // all investment which are available to withdraw by all Investors\n', '      uint to_withdraw; // available funds to withdraw for this particular Investor\n', '      for(uint8 i=0; i < financePeriodsCount-1; i++) {\n', '        if(now<financePeriodsTimestamps[i]) { // find end timestamp of current financial period          \n', '          remained = totalInvested - ((i+1)*totalInvested)/financePeriodsCount; // remained investment to withdraw by all Investors \n', '          to_withdraw = (saleStat[msg.sender].invested*remained)/totalInvested; // investment to withdraw by this Investor\n', '          uint sale_stakes_to_burn = saleStat[msg.sender].stakes+saleStat[msg.sender].bonusStakes; // returning all Stakes saved in saleStat[msg.sender]\n', '          uint team_stakes_to_burn = (saleStat[msg.sender].stakes*teamShare)/saleShare; // team Stakes are also burned\n', '          balances[owner] = balances[owner].sub(team_stakes_to_burn); // burn appropriate team Stakes\n', '          distributedTeamStakes -= team_stakes_to_burn; // remove team Stakes from distribution         \n', '          balances[msg.sender] = balances[msg.sender].sub(sale_stakes_to_burn); // burn stakes got for invested wei\n', '          totalInvested = totalInvested.sub(to_withdraw); // decrease invested total value\n', '          totalSupply = totalSupply.sub(sale_stakes_to_burn).sub(team_stakes_to_burn); // totalSupply is decreased\n', '          distributedSaleStakes -= saleStat[msg.sender].stakes;\n', '          if(saleStat[msg.sender].guide != address(0)) { // we have Guide and bonusStakes\n', '            // potential reward for the Guide is decreased proportionally\n', '            guidesStat[saleStat[msg.sender].guide].accumulatedPotentialReward -= (saleStat[msg.sender].guideReward - ((i+1)*saleStat[msg.sender].guideReward)/financePeriodsCount); \n', '            distributedBonusStakes -= saleStat[msg.sender].bonusStakes;\n', '            saleStat[msg.sender].bonusStakes = 0;\n', '            saleStat[msg.sender].guideReward = 0;          \n', '          }\n', '          saleStat[msg.sender].stakes = 0; // nullify Stakes recieved value          \n', '          saleStat[msg.sender].invested = 0; // nullify wei invested value\n', '          totalWithdrawn += to_withdraw;\n', '          msg.sender.transfer(to_withdraw); // witdraw investment\n', '          InvestmentWithdrawn(msg.sender, to_withdraw, sale_stakes_to_burn, financePeriodsCount-i-1);          \n', '          break;  \n', '        }\n', '      }      \n', '    }\n', '  /**\n', '   * @dev Distribute bounty rewards for bounty tasks\n', '   * @param _to is address of bounty hunter\n', '   * @param _stakes is quantity of Stakes transfered       \n', '   */     \n', '    function distributeBounty(address _to, uint _stakes) public onlyOwner {\n', '      require(distributedBountyStakes+_stakes <= bountyCap); // no more then maximum capacity can be distributed\n', '      balances[_to] = balances[_to].add(_stakes); // to\n', '      totalSupply += _stakes; \n', '      distributedBountyStakes += _stakes; // adding to total bounty distributed\n', '      BountyDistributed(_to, _stakes);    \n', '    }  \n', '  /**\n', '   * @dev Unfreeze team Stakes. Only after excessed Stakes have burned.\n', '   */      \n', '    function unFreeze() public onlyOwner {\n', '      // only after planned period\n', '      if(now > businessPlannedPeriodEndTimestamp) {\n', '        teamStakesFrozen = false; // make team stakes available for transfering\n', '      }  \n', '    }\n', '}']