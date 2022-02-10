['// SPDX-License-Identifier: MIT\n', '\n', 'pragma solidity =0.5.16;\n', '\n', "import {Math} from '../libraries/Math.sol';\n", "import {Setters} from './Setters.sol';\n", "import {IIncentiveController} from '../interfaces/IIncentiveController.sol';\n", "import {IMahaswapV1Pair} from '../interfaces/IMahaswapV1Pair.sol';\n", "import {Epoch} from '../Epoch.sol';\n", "import {IBurnableERC20} from '../interfaces/IBurnableERC20.sol';\n", '\n', '/**\n', ' * NOTE: Contract MahaswapV1Pair should be the owner of this controller.\n', ' */\n', 'contract ArthIncentiveController is IIncentiveController, Setters, Epoch {\n', '    /**\n', '     * Constructor.\n', '     */\n', '    constructor(\n', '        address _pairAddress,\n', '        address _protocolTokenAddress,\n', '        address _ecosystemFund,\n', '        address _incentiveToken,\n', '        uint256 _rewardPerEpoch,\n', '        uint256 _arthToMahaRate,\n', '        uint256 _period\n', '    )\n', '        public\n', '        Epoch(\n', '            _period, /* 12 hour epochs */\n', '            block.timestamp,\n', '            0\n', '        )\n', '    {\n', '        pairAddress = _pairAddress;\n', '        ecosystemFund = _ecosystemFund;\n', '        protocolTokenAddress = _protocolTokenAddress;\n', '        incentiveToken = IBurnableERC20(_incentiveToken);\n', '        isTokenAProtocolToken = IMahaswapV1Pair(_pairAddress).token0() == _protocolTokenAddress;\n', '        rewardPerEpoch = _rewardPerEpoch;\n', '        arthToMahaRate = _arthToMahaRate;\n', '\n', '        availableRewardThisEpoch = rewardPerEpoch;\n', '        rewardsThisEpoch = rewardPerEpoch;\n', '    }\n', '\n', '    function estimatePenaltyToCharge(\n', '        uint256 endingPrice,\n', '        uint256 liquidity,\n', '        uint256 sellVolume\n', '    ) public view returns (uint256) {\n', '        uint256 targetPrice = getPenaltyPrice();\n', '\n', '        // % of pool = sellVolume / liquidity\n', '        // % of deviation from target price = (tgt_price - price) / price\n', '        // amountToburn = sellVolume * % of deviation from target price * % of pool * 100\n', '        if (endingPrice >= targetPrice) return 0;\n', '\n', '        uint256 percentOfPool = sellVolume.mul(100000000).div(liquidity);\n', '        uint256 deviationFromTarget = targetPrice.sub(endingPrice).mul(100000000).div(targetPrice);\n', '\n', '        // A number from 0-100%.\n', '        uint256 feeToCharge = Math.max(percentOfPool, deviationFromTarget);\n', '\n', "        // NOTE: Shouldn't this be multiplied by 10000 instead of 100\n", '        // NOTE: multiplication by 100, is removed in the mock controller\n', '        // Can 2x, 3x, ... the penalty.\n', '        return sellVolume.mul(feeToCharge).mul(arthToMahaRate).mul(penaltyMultiplier).div(100000000 * 100000 * 1e18);\n', '    }\n', '\n', '    function estimateRewardToGive(\n', '        uint256 startingPrice,\n', '        uint256 liquidity,\n', '        uint256 buyVolume\n', '    ) public view returns (uint256) {\n', '        uint256 targetPrice = getRewardIncentivePrice();\n', '\n', '        // % of pool = buyVolume / liquidity\n', '        // % of deviation from target price = (tgt_price - price) / price\n', '        // rewardToGive = buyVolume * % of deviation from target price * % of pool * 100\n', '        if (startingPrice >= targetPrice) return 0;\n', '\n', '        uint256 percentOfPool = buyVolume.mul(100000000).div(liquidity);\n', '        uint256 deviationFromTarget = targetPrice.sub(startingPrice).mul(100000000).div(targetPrice);\n', '\n', '        // A number from 0-100%.\n', '        uint256 rewardToGive = percentOfPool.mul(deviationFromTarget).div(100000000);\n', '\n', '        uint256 _rewardsThisEpoch = _getUpdatedRewardsPerEpoch();\n', '\n', '        uint256 calculatedRewards =\n', '            _rewardsThisEpoch.mul(rewardToGive).mul(rewardMultiplier).mul(arthToMahaRate).div(\n', '                100000000 * 100000 * 1e18\n', '            );\n', '\n', '        uint256 availableRewards = Math.min(incentiveToken.balanceOf(address(this)), availableRewardThisEpoch);\n', '\n', '        return Math.min(availableRewards, calculatedRewards);\n', '    }\n', '\n', '    function _penalizeTrade(\n', '        uint256 endingPrice,\n', '        uint256 sellVolume,\n', '        uint256 liquidity,\n', '        address to\n', '    ) private {\n', '        uint256 amountToPenalize = estimatePenaltyToCharge(endingPrice, liquidity, sellVolume);\n', '\n', '        if (amountToPenalize > 0) {\n', '            // NOTE: amount has to be approved from frontend.\n', '            // take maha from owner\n', '            incentiveToken.transferFrom(to, address(this), amountToPenalize);\n', '\n', '            // Burn and charge a fraction of the penalty.\n', '            incentiveToken.burn(amountToPenalize.mul(penaltyToBurn).div(100));\n', '\n', '            // Keep a fraction of the penalty as funds for paying out rewards.\n', '            uint256 amountToKeep = amountToPenalize.mul(penaltyToKeep).div(100);\n', '\n', '            // Increase the variable to reflect this transfer.\n', '            rewardCollectedFromPenalties = rewardCollectedFromPenalties.add(amountToKeep);\n', '\n', '            // Send a fraction of the penalty to fund the ecosystem.\n', '            incentiveToken.transfer(ecosystemFund, amountToPenalize.mul(penaltyToRedirect).div(100));\n', '        }\n', '    }\n', '\n', '    function _incentiviseTrade(\n', '        uint256 startingPrice,\n', '        uint256 buyVolume,\n', '        uint256 liquidity,\n', '        address to\n', '    ) private {\n', '        // Calculate the amount as per volumne and rate.\n', '        uint256 amountToReward = estimateRewardToGive(startingPrice, liquidity, buyVolume);\n', '\n', '        if (amountToReward > 0) {\n', '            availableRewardThisEpoch = availableRewardThisEpoch.sub(amountToReward);\n', '\n', '            // Send reward to the appropriate address.\n', '            incentiveToken.transfer(to, amountToReward);\n', '        }\n', '    }\n', '\n', '    /**\n', '     * This is the function that burns the MAHA and returns how much ARTH should\n', '     * actually be spent.\n', '     *\n', '     * Note we are always selling tokenA.\n', '     */\n', '    function conductChecks(\n', '        uint112 reserveA,\n', '        uint112 reserveB,\n', '        uint256 priceALast,\n', '        uint256 priceBLast,\n', '        uint256 amountOutA,\n', '        uint256 amountOutB,\n', '        uint256 amountInA,\n', '        uint256 amountInB,\n', '        address from,\n', '        address to\n', '    ) external onlyPair {\n', '        // calculate price after the trade has been made\n', '        uint256 reserveAFinal = uint256(reserveA) + amountInA - amountOutA;\n', '        uint256 reserveBFinal = uint256(reserveB) + amountInB - amountOutB;\n', '\n', '        uint256 startingPriceA = uint256(reserveB).mul(1e18).div(uint256(reserveA));\n', '        uint256 endingPriceA = uint256(reserveBFinal).mul(1e18).div(uint256(reserveAFinal));\n', '\n', '        if (isTokenAProtocolToken) {\n', '            // then A is ARTH\n', '            _conductChecks(reserveA, startingPriceA, endingPriceA, amountOutA, amountInA, to);\n', '            return;\n', '        } else {\n', '            // then B is ARTH\n', '            uint256 startingPriceB = uint256(1e18).div(startingPriceA);\n', '            uint256 endingPriceB = uint256(1e18).div(endingPriceA);\n', '            _conductChecks(reserveB, startingPriceB, endingPriceB, amountOutB, amountInB, to);\n', '            return;\n', '        }\n', '    }\n', '\n', '    function _conductChecks(\n', '        uint112 reserveA, // ARTH liquidity\n', '        uint256 startingPriceA, // ARTH price\n', '        uint256 endingPriceA, // ARTH price\n', '        uint256 amountOutA, // ARTH being bought\n', '        uint256 amountInA, // ARTH being sold\n', '        address to\n', '    ) private {\n', '        // capture volume and snapshot it every epoch.\n', '        if (getCurrentEpoch() >= getNextEpoch()) _updateForEpoch();\n', '\n', '        // Check if we are selling and if we are blow the target price?\n', '        if (amountInA > 0) {\n', '            // Check if we are below the targetPrice.\n', '            uint256 penaltyTargetPrice = getPenaltyPrice();\n', '\n', '            if (endingPriceA < penaltyTargetPrice) {\n', '                // is the user expecting some DAI? if so then this is a sell order\n', '                // Calculate the amount of tokens sent.\n', '                _penalizeTrade(endingPriceA, amountInA, reserveA, to);\n', '\n', '                // stop here to save gas\n', '                return;\n', '            }\n', '        }\n', '\n', '        // Check if we are buying and below the target price\n', '        if (amountOutA > 0 && startingPriceA < getRewardIncentivePrice() && availableRewardThisEpoch > 0) {\n', '            // is the user expecting some ARTH? if so then this is a sell order\n', '            // If we are buying the main protocol token, then we incentivize the tx sender.\n', '            _incentiviseTrade(startingPriceA, amountOutA, reserveA, to);\n', '        }\n', '    }\n', '\n', '    function _updateForEpoch() private {\n', '        // Consider the reward pending from previous epoch and\n', '        // rewards capacity that was increased from penalizing people (AIP9 2nd point).\n', '        availableRewardThisEpoch = rewardPerEpoch.add(rewardCollectedFromPenalties);\n', '        rewardsThisEpoch = rewardPerEpoch.add(rewardCollectedFromPenalties);\n', '        rewardCollectedFromPenalties = 0;\n', '\n', '        lastExecutedAt = block.timestamp;\n', '    }\n', '\n', '    function _getUpdatedRewardsPerEpoch() private view returns (uint256) {\n', '        if (getCurrentEpoch() >= getNextEpoch()) {\n', '            return Math.max(rewardsThisEpoch, rewardPerEpoch.add(rewardCollectedFromPenalties));\n', '        }\n', '\n', '        return rewardsThisEpoch;\n', '    }\n', '\n', '    function refundIncentiveToken() external onlyOwner {\n', '        incentiveToken.transfer(msg.sender, incentiveToken.balanceOf(address(this)));\n', '    }\n', '}\n', '\n', '// SPDX-License-Identifier: MIT\n', '\n', 'pragma solidity =0.5.16;\n', '\n', '/**\n', ' * A library for performing various math operations\n', ' */\n', 'library Math {\n', '    function min(uint256 x, uint256 y) internal pure returns (uint256 z) {\n', '        z = x < y ? x : y;\n', '    }\n', '\n', '    function max(uint256 x, uint256 y) internal pure returns (uint256 z) {\n', '        z = x > y ? x : y;\n', '    }\n', '\n', '    // Babylonian method (https://en.wikipedia.org/wiki/Methods_of_computing_square_roots#Babylonian_method)\n', '    function sqrt(uint256 y) internal pure returns (uint256 z) {\n', '        if (y > 3) {\n', '            z = y;\n', '\n', '            uint256 x = y / 2 + 1;\n', '\n', '            while (x < z) {\n', '                z = x;\n', '                x = (y / x + x) / 2;\n', '            }\n', '        } else if (y != 0) {\n', '            z = 1;\n', '        }\n', '    }\n', '}\n', '\n', '// SPDX-License-Identifier: MIT\n', '\n', 'pragma solidity =0.5.16;\n', '\n', "import {Getters} from './Getters.sol';\n", "import {IBurnableERC20} from '../interfaces/IBurnableERC20.sol';\n", '\n', '/**\n', ' * NOTE: Contract MahaswapV1Pair should be the owner of this controller.\n', ' */\n', 'contract Setters is Getters {\n', '    /**\n', '     * Setters.\n', '     */\n', '    function setArthToMahaRate(uint256 val) external onlyOwner {\n', '        arthToMahaRate = val;\n', '    }\n', '\n', '    function setPenaltyToBurn(uint256 percent) public onlyOwner {\n', "        require(percent > 0 && percent < 100, 'Controller: invalid %');\n", '        penaltyToBurn = percent;\n', '    }\n', '\n', '    function setPenaltyToRedirect(uint256 percent) public onlyOwner {\n', "        require(percent > 0 && percent < 100, 'Controller: invalid %');\n", '        penaltyToRedirect = percent;\n', '    }\n', '\n', '    function setPenaltyToKeep(uint256 percent) public onlyOwner {\n', "        require(percent > 0 && percent < 100, 'Controller: invalid %');\n", '        penaltyToKeep = percent;\n', '    }\n', '\n', '    function setEcosystemFund(address fund) external onlyOwner {\n', '        ecosystemFund = fund;\n', '    }\n', '\n', '    function setRewardMultiplier(uint256 multiplier) public onlyOwner {\n', '        rewardMultiplier = multiplier;\n', '    }\n', '\n', '    function setPenaltyMultiplier(uint256 multiplier) public onlyOwner {\n', '        penaltyMultiplier = multiplier;\n', '    }\n', '\n', '    function setIncentiveToken(address newToken) public onlyOwner {\n', "        require(newToken != address(0), 'Pair: invalid token');\n", '        incentiveToken = IBurnableERC20(newToken);\n', '    }\n', '\n', '    function setPenaltyPrice(uint256 val) public onlyOwner {\n', '        penaltyPrice = val;\n', '    }\n', '\n', '    function setRewardPrice(uint256 val) public onlyOwner {\n', '        rewardPrice = val;\n', '    }\n', '\n', '    function setTokenAProtocolToken(bool val) public onlyOwner {\n', '        isTokenAProtocolToken = val;\n', '    }\n', '\n', '    function setAvailableRewardThisEpoch(uint256 val) public onlyOwner {\n', '        availableRewardThisEpoch = val;\n', '    }\n', '\n', '    function setMahaPerEpoch(uint256 val) public onlyOwner {\n', '        rewardPerEpoch = val;\n', '    }\n', '\n', '    function setUseOracle(bool val) public onlyOwner {\n', '        useOracle = val;\n', '    }\n', '}\n', '\n', '// SPDX-License-Identifier: MIT\n', '\n', 'pragma solidity >=0.5.0;\n', '\n', 'interface IIncentiveController {\n', '    function conductChecks(\n', '        uint112 reserveA,\n', '        uint112 reserveB,\n', '        uint256 priceALast,\n', '        uint256 priceBLast,\n', '        uint256 amountOutA,\n', '        uint256 amountOutB,\n', '        uint256 amountInA,\n', '        uint256 amountInB,\n', '        address from,\n', '        address to\n', '    ) external;\n', '}\n', '\n', '// SPDX-License-Identifier: MIT\n', '\n', 'pragma solidity >=0.5.0;\n', '\n', 'interface IMahaswapV1Pair {\n', '    function MINIMUM_LIQUIDITY() external pure returns (uint256);\n', '\n', '    function factory() external view returns (address);\n', '\n', '    function token0() external view returns (address);\n', '\n', '    function token1() external view returns (address);\n', '\n', '    function price0CumulativeLast() external view returns (uint256);\n', '\n', '    function price1CumulativeLast() external view returns (uint256);\n', '\n', '    function kLast() external view returns (uint256);\n', '\n', '    function getReserves()\n', '        external\n', '        view\n', '        returns (\n', '            uint112 reserve0,\n', '            uint112 reserve1,\n', '            uint32 blockTimestampLast\n', '        );\n', '\n', '    function mint(address to) external returns (uint256 liquidity);\n', '\n', '    function burn(address to) external returns (uint256 amount0, uint256 amount1);\n', '\n', '    function swap(\n', '        uint256 amount0Out,\n', '        uint256 amount1Out,\n', '        address to,\n', '        bytes calldata data\n', '    ) external;\n', '\n', '    function skim(address to) external;\n', '\n', '    function sync() external;\n', '\n', '    function initialize(address, address) external;\n', '\n', '    function setSwapingPaused(bool isSet) external;\n', '\n', '    function setIncentiveController(address controller) external;\n', '\n', '    event Mint(address indexed sender, uint256 amount0, uint256 amount1);\n', '    event Burn(address indexed sender, uint256 amount0, uint256 amount1, address indexed to);\n', '    event Swap(\n', '        address indexed sender,\n', '        uint256 amount0In,\n', '        uint256 amount1In,\n', '        uint256 amount0Out,\n', '        uint256 amount1Out,\n', '        address indexed to\n', '    );\n', '    event Sync(uint112 reserve0, uint112 reserve1);\n', '}\n', '\n', '// SPDX-License-Identifier: MIT\n', '\n', 'pragma solidity =0.5.16;\n', '\n', "import './libraries/SafeMath.sol';\n", "import './libraries/Math.sol';\n", "import './libraries/Ownable.sol';\n", '\n', 'contract Epoch is Ownable {\n', '    using SafeMath for uint256;\n', '\n', '    uint256 public period = 1;\n', '    uint256 public startTime;\n', '    uint256 public lastExecutedAt;\n', '\n', '    /* ========== CONSTRUCTOR ========== */\n', '\n', '    constructor(\n', '        uint256 _period,\n', '        uint256 _startTime,\n', '        uint256 _startEpoch\n', '    ) public {\n', "        // require(_startTime > block.timestamp, 'Epoch: invalid start time');\n", '        period = _period;\n', '        startTime = _startTime;\n', '        lastExecutedAt = startTime.add(_startEpoch.mul(period));\n', '    }\n', '\n', '    /* ========== Modifier ========== */\n', '\n', '    modifier checkStartTime {\n', "        require(now >= startTime, 'Epoch: not started yet');\n", '\n', '        _;\n', '    }\n', '\n', '    /* ========== VIEW FUNCTIONS ========== */\n', '\n', '    function canUpdate() public view returns (bool) {\n', '        return getCurrentEpoch() >= getNextEpoch();\n', '    }\n', '\n', '    function getLastEpoch() public view returns (uint256) {\n', '        return lastExecutedAt.sub(startTime).div(period);\n', '    }\n', '\n', '    function getCurrentEpoch() public view returns (uint256) {\n', '        return Math.max(startTime, block.timestamp).sub(startTime).div(period);\n', '    }\n', '\n', '    function getNextEpoch() public view returns (uint256) {\n', '        if (startTime == lastExecutedAt) {\n', '            return getLastEpoch();\n', '        }\n', '        return getLastEpoch().add(1);\n', '    }\n', '\n', '    function nextEpochPoint() public view returns (uint256) {\n', '        return startTime.add(getNextEpoch().mul(period));\n', '    }\n', '\n', '    function getPeriod() public view returns (uint256) {\n', '        return period;\n', '    }\n', '\n', '    function getStartTime() public view returns (uint256) {\n', '        return startTime;\n', '    }\n', '\n', '    function setPeriod(uint256 _period) external onlyOwner {\n', '        period = _period;\n', '    }\n', '}\n', '\n', '// SPDX-License-Identifier: MIT\n', '\n', 'pragma solidity >=0.5.0;\n', '\n', "import './IERC20.sol';\n", '\n', 'interface IBurnableERC20 {\n', '    event Approval(address indexed owner, address indexed spender, uint256 value);\n', '    event Transfer(address indexed from, address indexed to, uint256 value);\n', '\n', '    function name() external view returns (string memory);\n', '\n', '    function symbol() external view returns (string memory);\n', '\n', '    function decimals() external view returns (uint8);\n', '\n', '    function totalSupply() external view returns (uint256);\n', '\n', '    function balanceOf(address owner) external view returns (uint256);\n', '\n', '    function allowance(address owner, address spender) external view returns (uint256);\n', '\n', '    function approve(address spender, uint256 value) external returns (bool);\n', '\n', '    function transfer(address to, uint256 value) external returns (bool);\n', '\n', '    function transferFrom(\n', '        address from,\n', '        address to,\n', '        uint256 value\n', '    ) external returns (bool);\n', '\n', '    function burnFrom(address account, uint256 amount) external;\n', '\n', '    function burn(uint256 amount) external;\n', '}\n', '\n', '// SPDX-License-Identifier: MIT\n', '\n', 'pragma solidity =0.5.16;\n', '\n', "import {State} from './State.sol';\n", '\n', '/**\n', ' * NOTE: Contract MahaswapV1Pair should be the owner of this controller.\n', ' */\n', 'contract Getters is State {\n', '    function getPenaltyPrice() public view returns (uint256) {\n', '        // If (useOracle) then get penalty price from an oracle\n', '        // else get from a variable.\n', '        // This variable is settable from the factory.\n', '        return penaltyPrice;\n', '    }\n', '\n', '    function getRewardIncentivePrice() public view returns (uint256) {\n', '        // If (useOracle) then get reward price from an oracle\n', '        // else get from a variable.\n', '        // This variable is settable from the factory.\n', '        return rewardPrice;\n', '    }\n', '}\n', '\n', '// SPDX-License-Identifier: MIT\n', '\n', 'pragma solidity =0.5.16;\n', '\n', "import {SafeMath} from '../libraries/SafeMath.sol';\n", "import {UQ112x112} from '../libraries/UQ112x112.sol';\n", "import {IBurnableERC20} from '../interfaces/IBurnableERC20.sol';\n", "import {IUniswapOracle} from '../interfaces/IUniswapOracle.sol';\n", "import {Ownable} from '../libraries/Ownable.sol';\n", '\n', '/**\n', ' * NOTE: Contract MahaswapV1Pair should be the owner of this controller.\n', ' */\n', 'contract State is Ownable {\n', '    using SafeMath for uint256;\n', '    using UQ112x112 for uint224;\n', '\n', '    // Token which will be used to charge penalty or reward incentives.\n', '    IBurnableERC20 public incentiveToken;\n', '\n', '    // Pair that will be using this contract.\n', '    address public pairAddress;\n', '\n', '    // Token which is the main token of a protocol.\n', '    address public protocolTokenAddress;\n', '\n', '    // A fraction of penalty is being used to fund the ecosystem.\n', '    address ecosystemFund;\n', '\n', '    // Used to track the latest twap price.\n', '    IUniswapOracle public uniswapOracle;\n', '\n', '    // Default price of when reward is to be given.\n', '    uint256 public rewardPrice = uint256(110).mul(1e16); // ~1.2$\n', '    // Default price of when penalty is to be charged.\n', '    uint256 public penaltyPrice = uint256(110).mul(1e16); // ~0.95$\n', '\n', '    // Should we use oracle to get diff. price feeds or not.\n', '    bool public useOracle = false;\n', '\n', '    bool public isTokenAProtocolToken = true;\n', '\n', '    // Max. reward per hour to be given out.\n', '    uint256 public rewardPerEpoch = 0;\n', '\n', '    // Multipiler for rewards and penalty.\n', '    uint256 public rewardMultiplier = 5 * 100000; // 5x\n', '    uint256 public penaltyMultiplier = 10 * 100000; // 10x\n', '\n', "    // Percentage of penalty to be burnt from the token's supply.\n", '    uint256 public penaltyToBurn = uint256(45); // In %.\n', '    // Percentage of penalty to be kept inside this contract to act as fund for rewards.\n', '    uint256 public penaltyToKeep = uint256(45); // In %.\n', '    // Percentage of penalty to be redirected to diff. funds(currently ecosystem fund).\n', '    uint256 public penaltyToRedirect = uint256(10); // In %.\n', '\n', '    // The reward which can be given out during this epoch.\n', '    uint256 public availableRewardThisEpoch = 0;\n', '    uint256 public rewardsThisEpoch = 0;\n', '\n', '    // The reward which has been collected through the penalities accross all epochs.\n', '    uint256 public rewardCollectedFromPenalties = 0;\n', '\n', '    uint256 public arthToMahaRate;\n', '\n', '    /**\n', '     * Modifier.\n', '     */\n', '    modifier onlyPair {\n', "        require(msg.sender == pairAddress, 'Controller: Forbidden');\n", '        _;\n', '    }\n', '}\n', '\n', '// SPDX-License-Identifier: MIT\n', '\n', 'pragma solidity =0.5.16;\n', '\n', '/**\n', ' * A library for performing overflow-safe math, courtesy of DappHub (https://github.com/dapphub/ds-math)\n', ' */\n', 'library SafeMath {\n', '    /**\n', '     * @dev Returns the addition of two unsigned integers, reverting on\n', '     * overflow.\n', '     *\n', "     * Counterpart to Solidity's `+` operator.\n", '     *\n', '     * Requirements:\n', '     *\n', '     * - Addition cannot overflow.\n', '     */\n', '    function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        uint256 c = a + b;\n', "        require(c >= a, 'SafeMath: addition overflow');\n", '\n', '        return c;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the subtraction of two unsigned integers, reverting on\n', '     * overflow (when the result is negative).\n', '     *\n', "     * Counterpart to Solidity's `-` operator.\n", '     *\n', '     * Requirements:\n', '     *\n', '     * - Subtraction cannot overflow.\n', '     */\n', '    function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', "        return sub(a, b, 'SafeMath: subtraction overflow');\n", '    }\n', '\n', '    /**\n', '     * @dev Returns the subtraction of two unsigned integers, reverting with custom message on\n', '     * overflow (when the result is negative).\n', '     *\n', "     * Counterpart to Solidity's `-` operator.\n", '     *\n', '     * Requirements:\n', '     *\n', '     * - Subtraction cannot overflow.\n', '     */\n', '    function sub(\n', '        uint256 a,\n', '        uint256 b,\n', '        string memory errorMessage\n', '    ) internal pure returns (uint256) {\n', '        require(b <= a, errorMessage);\n', '        uint256 c = a - b;\n', '\n', '        return c;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the multiplication of two unsigned integers, reverting on\n', '     * overflow.\n', '     *\n', "     * Counterpart to Solidity's `*` operator.\n", '     *\n', '     * Requirements:\n', '     *\n', '     * - Multiplication cannot overflow.\n', '     */\n', '    function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', "        // Gas optimization: this is cheaper than requiring 'a' not being zero, but the\n", "        // benefit is lost if 'b' is also tested.\n", '        // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522\n', '        if (a == 0) {\n', '            return 0;\n', '        }\n', '\n', '        uint256 c = a * b;\n', "        require(c / a == b, 'SafeMath: multiplication overflow');\n", '\n', '        return c;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the integer division of two unsigned integers. Reverts on\n', '     * division by zero. The result is rounded towards zero.\n', '     *\n', "     * Counterpart to Solidity's `/` operator. Note: this function uses a\n", '     * `revert` opcode (which leaves remaining gas untouched) while Solidity\n', '     * uses an invalid opcode to revert (consuming all remaining gas).\n', '     *\n', '     * Requirements:\n', '     *\n', '     * - The divisor cannot be zero.\n', '     */\n', '    function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', "        return div(a, b, 'SafeMath: division by zero');\n", '    }\n', '\n', '    /**\n', '     * @dev Returns the integer division of two unsigned integers. Reverts with custom message on\n', '     * division by zero. The result is rounded towards zero.\n', '     *\n', "     * Counterpart to Solidity's `/` operator. Note: this function uses a\n", '     * `revert` opcode (which leaves remaining gas untouched) while Solidity\n', '     * uses an invalid opcode to revert (consuming all remaining gas).\n', '     *\n', '     * Requirements:\n', '     *\n', '     * - The divisor cannot be zero.\n', '     */\n', '    function div(\n', '        uint256 a,\n', '        uint256 b,\n', '        string memory errorMessage\n', '    ) internal pure returns (uint256) {\n', '        require(b > 0, errorMessage);\n', '        uint256 c = a / b;\n', "        // assert(a == b * c + a % b); // There is no case in which this doesn't hold\n", '\n', '        return c;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),\n', '     * Reverts when dividing by zero.\n', '     *\n', "     * Counterpart to Solidity's `%` operator. This function uses a `revert`\n", '     * opcode (which leaves remaining gas untouched) while Solidity uses an\n', '     * invalid opcode to revert (consuming all remaining gas).\n', '     *\n', '     * Requirements:\n', '     *\n', '     * - The divisor cannot be zero.\n', '     */\n', '    function mod(uint256 a, uint256 b) internal pure returns (uint256) {\n', "        return mod(a, b, 'SafeMath: modulo by zero');\n", '    }\n', '\n', '    /**\n', '     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),\n', '     * Reverts with custom message when dividing by zero.\n', '     *\n', "     * Counterpart to Solidity's `%` operator. This function uses a `revert`\n", '     * opcode (which leaves remaining gas untouched) while Solidity uses an\n', '     * invalid opcode to revert (consuming all remaining gas).\n', '     *\n', '     * Requirements:\n', '     *\n', '     * - The divisor cannot be zero.\n', '     */\n', '    function mod(\n', '        uint256 a,\n', '        uint256 b,\n', '        string memory errorMessage\n', '    ) internal pure returns (uint256) {\n', '        require(b != 0, errorMessage);\n', '        return a % b;\n', '    }\n', '}\n', '\n', '// SPDX-License-Identifier: MIT\n', '\n', 'pragma solidity =0.5.16;\n', '\n', '/**\n', ' * A library for handling binary fixed point numbers (https://en.wikipedia.org/wiki/Q_(number_format))\n', ' * range: [0, 2**112 - 1]\n', ' * resolution: 1 / 2**112\n', ' */\n', 'library UQ112x112 {\n', '    uint224 constant Q112 = 2**112;\n', '\n', '    // Encode a uint112 as a UQ112x112\n', '    function encode(uint112 y) internal pure returns (uint224 z) {\n', '        z = uint224(y) * Q112; // never overflows\n', '    }\n', '\n', '    // Multiply a UQ112x112 by a uint112, returning a UQ112x112\n', '    function uqmul(uint224 x, uint112 y) internal pure returns (uint224 z) {\n', '        z = x * uint224(y);\n', '    }\n', '\n', '    // Divide a UQ112x112 by a uint112, returning a UQ112x112\n', '    function uqdiv(uint224 x, uint112 y) internal pure returns (uint224 z) {\n', '        z = x / uint224(y);\n', '    }\n', '}\n', '\n', '// SPDX-License-Identifier: MIT\n', '\n', 'pragma solidity >=0.5.0;\n', '\n', 'interface IUniswapOracle {\n', '    function update() external;\n', '\n', '    function consult(address token, uint256 amountIn) external view returns (uint256 amountOut);\n', '}\n', '\n', '// SPDX-License-Identifier: MIT\n', '\n', 'pragma solidity =0.5.16;\n', '\n', '/**\n', ' * @dev Contract module which provides a basic access control mechanism, where\n', ' * there is an account (an owner) that can be granted exclusive access to\n', ' * specific functions.\n', ' *\n', ' * By default, the owner account will be the one that deploys the contract. This\n', ' * can later be changed with {transferOwnership}.\n', ' *\n', ' * This module is used through inheritance. It will make available the modifier\n', ' * `onlyOwner`, which can be applied to your functions to restrict their use to\n', ' * the owner.\n', ' */\n', 'contract Ownable {\n', '    address private _owner;\n', '\n', '    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);\n', '\n', '    /**\n', '     * @dev Initializes the contract setting the deployer as the initial owner.\n', '     */\n', '    constructor() internal {\n', '        _owner = msg.sender;\n', '        emit OwnershipTransferred(address(0), msg.sender);\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the address of the current owner.\n', '     */\n', '    function owner() public view returns (address) {\n', '        return _owner;\n', '    }\n', '\n', '    /**\n', '     * @dev Throws if called by any account other than the owner.\n', '     */\n', '    modifier onlyOwner() {\n', "        require(owner() == msg.sender, 'Ownable: caller is not the owner');\n", '        _;\n', '    }\n', '\n', '    /**\n', '     * @dev Leaves the contract without owner. It will not be possible to call\n', '     * `onlyOwner` functions anymore. Can only be called by the current owner.\n', '     *\n', '     * NOTE: Renouncing ownership will leave the contract without an owner,\n', '     * thereby removing any functionality that is only available to the owner.\n', '     */\n', '    function renounceOwnership() public onlyOwner {\n', '        emit OwnershipTransferred(_owner, address(0));\n', '        _owner = address(0);\n', '    }\n', '\n', '    /**\n', '     * @dev Transfers ownership of the contract to a new account (`newOwner`).\n', '     * Can only be called by the current owner.\n', '     */\n', '    function transferOwnership(address newOwner) public onlyOwner {\n', "        require(newOwner != address(0), 'Ownable: new owner is the zero address');\n", '        emit OwnershipTransferred(_owner, newOwner);\n', '        _owner = newOwner;\n', '    }\n', '}\n', '\n', '// SPDX-License-Identifier: MIT\n', '\n', 'pragma solidity >=0.5.0;\n', '\n', 'interface IERC20 {\n', '    event Approval(address indexed owner, address indexed spender, uint256 value);\n', '    event Transfer(address indexed from, address indexed to, uint256 value);\n', '\n', '    function name() external view returns (string memory);\n', '\n', '    function symbol() external view returns (string memory);\n', '\n', '    function decimals() external view returns (uint8);\n', '\n', '    function totalSupply() external view returns (uint256);\n', '\n', '    function balanceOf(address owner) external view returns (uint256);\n', '\n', '    function allowance(address owner, address spender) external view returns (uint256);\n', '\n', '    function approve(address spender, uint256 value) external returns (bool);\n', '\n', '    function transfer(address to, uint256 value) external returns (bool);\n', '\n', '    function transferFrom(\n', '        address from,\n', '        address to,\n', '        uint256 value\n', '    ) external returns (bool);\n', '}']