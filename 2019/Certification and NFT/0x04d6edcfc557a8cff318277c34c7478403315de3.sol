['pragma solidity 0.5.9;\n', '\n', '\n', '/**\n', ' * https://rekt.fyi\n', ' *\n', " * Mock the performance of your friend's ETH stack by sending them a REKT token, and add a bounty to it.\n", ' *\n', ' * REKT tokens are non-transferrable. Holders can only burn the token and collect the bounty once their\n', ' * ETH balance is m times higher or their ETH is worth m times more in USD than when they received the\n', ' * token, where m is a multiplier value set by users.\n', ' *\n', ' * copyright 2019 rekt.fyi\n', ' *\n', ' * This program is free software: you can redistribute it and/or modify\n', ' * it under the terms of the GNU General Public License as published by\n', ' * the Free Software Foundation, either version 3 of the License, or\n', ' * (at your option) any later version.\n', ' *\n', ' * This program is distributed in the hope that it will be useful,\n', ' * but WITHOUT ANY WARRANTY; without even the implied warranty of\n', ' * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the\n', ' * GNU General Public License for more details.\n', ' *\n', ' * You should have received a copy of the GNU General Public License\n', ' * along with this program.  If not, see <http://www.gnu.org/licenses/>.\n', ' */\n', '\n', '\n', '/**\n', ' * Libraries\n', ' */\n', '\n', '/// math.sol -- mixin for inline numerical wizardry\n', '\n', '// This program is free software: you can redistribute it and/or modify\n', '// it under the terms of the GNU General Public License as published by\n', '// the Free Software Foundation, either version 3 of the License, or\n', '// (at your option) any later version.\n', '\n', '// This program is distributed in the hope that it will be useful,\n', '// but WITHOUT ANY WARRANTY; without even the implied warranty of\n', '// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the\n', '// GNU General Public License for more details.\n', '\n', '// You should have received a copy of the GNU General Public License\n', '// along with this program.  If not, see <http://www.gnu.org/licenses/>.\n', '\n', 'library DSMath {\n', '    function add(uint x, uint y) internal pure returns (uint z) {\n', '        require((z = x + y) >= x);\n', '    }\n', '    function sub(uint x, uint y) internal pure returns (uint z) {\n', '        require((z = x - y) <= x);\n', '    }\n', '    function mul(uint x, uint y) internal pure returns (uint z) {\n', '        require(y == 0 || (z = x * y) / y == x);\n', '    }\n', '\n', '    function min(uint x, uint y) internal pure returns (uint z) {\n', '        return x <= y ? x : y;\n', '    }\n', '    function max(uint x, uint y) internal pure returns (uint z) {\n', '        return x >= y ? x : y;\n', '    }\n', '    function imin(int x, int y) internal pure returns (int z) {\n', '        return x <= y ? x : y;\n', '    }\n', '    function imax(int x, int y) internal pure returns (int z) {\n', '        return x >= y ? x : y;\n', '    }\n', '\n', '    uint constant WAD = 10 ** 18;\n', '    uint constant RAY = 10 ** 27;\n', '\n', '    function wmul(uint x, uint y) internal pure returns (uint z) {\n', '        z = add(mul(x, y), WAD / 2) / WAD;\n', '    }\n', '    function rmul(uint x, uint y) internal pure returns (uint z) {\n', '        z = add(mul(x, y), RAY / 2) / RAY;\n', '    }\n', '    function wdiv(uint x, uint y) internal pure returns (uint z) {\n', '        z = add(mul(x, WAD), y / 2) / y;\n', '    }\n', '    function rdiv(uint x, uint y) internal pure returns (uint z) {\n', '        z = add(mul(x, RAY), y / 2) / y;\n', '    }\n', '\n', '    // This famous algorithm is called "exponentiation by squaring"\n', '    // and calculates x^n with x as fixed-point and n as regular unsigned.\n', '    //\n', "    // It's O(log n), instead of O(n) for naive repeated multiplication.\n", '    //\n', '    // These facts are why it works:\n', '    //\n', '    //  If n is even, then x^n = (x^2)^(n/2).\n', '    //  If n is odd,  then x^n = x * x^(n-1),\n', '    //   and applying the equation for even x gives\n', '    //    x^n = x * (x^2)^((n-1) / 2).\n', '    //\n', '    //  Also, EVM division is flooring and\n', '    //    floor[(n-1) / 2] = floor[n / 2].\n', '    //\n', '    function rpow(uint x, uint n) internal pure returns (uint z) {\n', '        z = n % 2 != 0 ? x : RAY;\n', '\n', '        for (n /= 2; n != 0; n /= 2) {\n', '            x = rmul(x, x);\n', '\n', '            if (n % 2 != 0) {\n', '                z = rmul(z, x);\n', '            }\n', '        }\n', '    }\n', '}\n', '\n', '/**\n', ' * External Contracts\n', ' */\n', '\n', 'contract Medianizer {\n', '    function peek() public view returns (bytes32, bool) {}\n', '}\n', '\n', 'contract Dai {\n', '     function transferFrom(address src, address dst, uint wad) public returns (bool) {}\n', '}\n', '\n', '\n', '/**\n', ' * Contracts\n', ' */\n', '\n', '\n', '/**\n', ' * @title Ownable\n', ' * @dev The Ownable contract has an owner address, and provides basic authorization control\n', ' * functions, this simplifies the implementation of "user permissions".\n', ' */\n', 'contract Ownable {\n', '    address public owner;\n', '\n', '\n', '    event OwnershipRenounced(address indexed previousOwner);\n', '    event OwnershipTransferred(\n', '        address indexed previousOwner,\n', '        address indexed newOwner\n', '    );\n', '\n', '\n', '    /**\n', '    * @dev The Ownable constructor sets the original `owner` of the contract to the sender\n', '    * account.\n', '    */\n', '    constructor() public {\n', '        owner = msg.sender;\n', '    }\n', '\n', '    /**\n', '    * @dev Throws if called by any account other than the owner.\n', '    */\n', '    modifier onlyOwner() {\n', '        require(msg.sender == owner);\n', '        _;\n', '    }\n', '\n', '    /**\n', '    * @dev Allows the current owner to relinquish control of the contract.\n', '    * @notice Renouncing to ownership will leave the contract without an owner.\n', '    * It will not be possible to call the functions with the `onlyOwner`\n', '    * modifier anymore.\n', '    */\n', '    function renounceOwnership() public onlyOwner {\n', '        emit OwnershipRenounced(owner);\n', '        owner = address(0);\n', '    }\n', '\n', '    /**\n', '    * @dev Allows the current owner to transfer control of the contract to a newOwner.\n', '    * @param _newOwner The address to transfer ownership to.\n', '    */\n', '    function transferOwnership(address _newOwner) public onlyOwner {\n', '        _transferOwnership(_newOwner);\n', '    }\n', '\n', '    /**\n', '    * @dev Transfers control of the contract to a newOwner.\n', '    * @param _newOwner The address to transfer ownership to.\n', '    */\n', '    function _transferOwnership(address _newOwner) internal {\n', '        require(_newOwner != address(0));\n', '        emit OwnershipTransferred(owner, _newOwner);\n', '        owner = _newOwner;\n', '    }\n', '}\n', '\n', '\n', '/**\n', ' * @title https://rekt.fyi\n', " * @notice Mock the performance of your friend's ETH stack by sending them a REKT token, and add a bounty to it.\n", ' *\n', ' * REKT tokens are non-transferrable. Holders can only burn the token and collect the bounty once their\n', ' * ETH balance is m times higher or their ETH is worth m times more in USD than when they received the\n', ' * token, where m is a multiplier value set by users.\n', ' */\n', 'contract RektFyi is Ownable {\n', '\n', '    using DSMath for uint;\n', '\n', '    /**\n', '     * Storage\n', '     */\n', '\n', '    struct Receiver {\n', '        uint walletBalance;\n', '        uint bountyETH;\n', '        uint bountyDAI;\n', '        uint timestamp;\n', '        uint etherPrice;\n', '        address payable sender;\n', '    }\n', '\n', '    struct Vault {\n', '        uint fee;\n', '        uint bountyETH;\n', '        uint bountySAI; // DAI bounty sent here before the switch to MCD\n', '        uint bountyDAI; // DAI bounty sent here after the switch to MCD\n', '    }\n', '\n', '    struct Pot {\n', '        uint ETH;\n', '        uint DAI;\n', '    }\n', '\n', '\n', '    mapping(address => Receiver) public receiver;\n', '    mapping(address => uint) public balance;\n', '    mapping(address => address[]) private recipients;\n', '    mapping(address => Pot) public unredeemedBounty;\n', '    mapping(address => Vault) public vault;\n', '    Pot public bountyPot = Pot(0,0);\n', '    uint public feePot = 0;\n', '\n', '    bool public shutdown = false;\n', '    uint public totalSupply = 0;\n', '    uint public multiplier = 1300000000000000000; // 1.3x to start\n', '    uint public bumpBasePrice = 10000000000000000; // 0.01 ETH\n', '    uint public holdTimeCeiling = 3628800; // 6 weeks in seconds\n', '\n', '    address public medianizerAddress;\n', '    Medianizer oracle;\n', '\n', '    bool public isMCD = false;\n', '    uint public MCDswitchTimestamp = 0;\n', '    address public saiAddress;\n', '    address public daiAddress;\n', '\n', '    Dai dai;\n', '    Dai sai;\n', '\n', '\n', '    constructor(address _medianizerAddress, address _saiAddress) public {\n', '        medianizerAddress = _medianizerAddress;\n', '        oracle = Medianizer(medianizerAddress);\n', '\n', '        saiAddress = _saiAddress;\n', '        dai = Dai(saiAddress);\n', '        sai = dai;\n', '    }\n', '\n', '\n', '    /**\n', '     * Constants\n', '     */\n', '\n', '    string public constant name = "REKT.fyi";\n', '    string public constant symbol = "REKT";\n', '    uint8 public constant decimals = 0;\n', '\n', '    uint public constant WAD = 1000000000000000000;\n', '    uint public constant PRECISION = 100000000000000; // 4 orders of magnitude / decimal places\n', '    uint public constant MULTIPLIER_FLOOR = 1000000000000000000; // 1x\n', '    uint public constant MULTIPLIER_CEILING = 10000000000000000000; // 10x\n', '    uint public constant BONUS_FLOOR = 1250000000000000000; //1.25x \n', '    uint public constant BONUS_CEILING = 1800000000000000000; //1.8x\n', '    uint public constant BOUNTY_BONUS_MINIMUM = 5000000000000000000; // $5\n', '    uint public constant HOLD_SCORE_CEILING = 1000000000000000000000000000; // 1 RAY\n', '    uint public constant BUMP_INCREMENT = 100000000000000000; // 0.1x\n', '    uint public constant HOLD_TIME_MAX = 23670000; // 9 months is the maximum the owner can set with setHoldTimeCeiling(uint)\n', '    uint public constant BUMP_PRICE_MAX = 100000000000000000; //0.1 ETH is the maximum the owner can set with setBumpPrice(uint)\n', '\n', '\n', '    /**\n', '     * Events\n', '     */\n', '\n', '    event LogVaultDeposit(address indexed addr, string indexed potType, uint value);\n', '    event LogWithdraw(address indexed to, uint eth, uint sai, uint dai);\n', '    event Transfer(address indexed from, address indexed to, uint tokens);\n', '    event LogBump(uint indexed from, uint indexed to, uint cost, address indexed by);\n', '    event LogBurn(\n', '        address indexed sender,\n', '        address indexed receiver,\n', '        uint receivedAt,\n', '        uint multiplier,\n', '        uint initialETH,\n', '        uint etherPrice,\n', '        uint bountyETH,\n', '        uint bountyDAI,\n', '        uint reward\n', '        );\n', '    event LogGive(address indexed sender, address indexed receiver);\n', '\n', '\n', '    /**\n', '     * Modifiers\n', '     */\n', '\n', '    modifier shutdownNotActive() {\n', '        require(shutdown == false, "shutdown activated");\n', '        _;\n', '    }\n', '\n', '\n', '    modifier giveRequirementsMet(address _to) {\n', '        require(address(_to) != address(0), "Invalid address");\n', '        require(_to != msg.sender, "Cannot give to yourself");\n', '        require(balanceOf(_to) == 0, "Receiver already has a token");\n', '        require(_to.balance > 0, "Receiver wallet must not be empty");\n', '        _;\n', '    }\n', '\n', '\n', '    /**\n', '     * External functions\n', '     */\n', '\n', '    /// @notice Give somebody a REKT token, along with an optional bounty in ether.\n', '    /// @param _to The address to send the REKT token to.\n', '    function give(address _to) external payable shutdownNotActive giveRequirementsMet(_to) {\n', '        if (msg.value > 0) {\n', '            unredeemedBounty[msg.sender].ETH = unredeemedBounty[msg.sender].ETH.add(msg.value);\n', '            bountyPot.ETH = bountyPot.ETH.add(msg.value);\n', '        }\n', '        receiver[_to] = Receiver(_to.balance, msg.value, 0, now, getPrice(), msg.sender);\n', '        giveCommon(_to);\n', '    }\n', '\n', '\n', '    /// @notice Give somebody a REKT token, along with an option bounty in DAI.\n', '    /// @param _to The account to send the REKT token to.\n', '    /// @param _amount The amount of DAI to use as a bounty.\n', '    function giveWithDAI(address _to, uint _amount) external shutdownNotActive giveRequirementsMet(_to) {\n', '        if (_amount > 0) {\n', '            // If the switch has already been included in this block then MCD is active,\n', "            // but we won't be able to tell later if that's the case so block this tx.\n", '            // Its ok for the mcd switch to occur later than this function in the same block\n', '            require(MCDswitchTimestamp != now, "Cannot send DAI during the switching block");\n', '            require(dai.transferFrom(msg.sender, address(this), _amount), "DAI transfer failed");\n', '            unredeemedBounty[msg.sender].DAI = unredeemedBounty[msg.sender].DAI.add(_amount);\n', '            bountyPot.DAI = bountyPot.DAI.add(_amount);\n', '        }\n', '        receiver[_to] = Receiver(_to.balance, 0, _amount, now, getPrice(), msg.sender);\n', '        giveCommon(_to);\n', '    }\n', '\n', '\n', '    /// @notice Bump the multiplier up or down.\n', '    /// @dev Multiplier has PRECISION precision and is rounded down unless the unrounded\n', '    /// value hits the MULTIPLIER_CEILING or MULTIPLIER_FLOOR.\n', '    /// @param _up Boolean representing whether the direction of the bump is up or not.\n', '    function bump(bool _up) external payable shutdownNotActive {\n', '        require(msg.value > 0, "Ether required");\n', '        uint initialMultiplier = multiplier;\n', '\n', '        // amount = (value/price)*bonus*increment\n', '        uint bumpAmount = msg.value\n', '            .wdiv(bumpBasePrice)\n', '            .wmul(getBonusMultiplier(msg.sender))\n', '            .wmul(BUMP_INCREMENT);\n', '\n', '        if (_up) {\n', '            if (multiplier.add(bumpAmount) >= MULTIPLIER_CEILING) {\n', '                multiplier = MULTIPLIER_CEILING;\n', '            } else {\n', '                multiplier = multiplier.add(roundBumpAmount(bumpAmount));\n', '            }\n', '        }\n', '        else {\n', '            if (multiplier > bumpAmount) {\n', '                if (multiplier.sub(bumpAmount) <= MULTIPLIER_FLOOR) {\n', '                    multiplier = MULTIPLIER_FLOOR;\n', '                } else {\n', '                    multiplier = multiplier.sub(roundBumpAmount(bumpAmount));\n', '                }\n', '            }\n', '            else {\n', '                multiplier = MULTIPLIER_FLOOR;\n', '            }\n', '        }\n', '\n', '        emit LogBump(initialMultiplier, multiplier, msg.value, msg.sender);\n', '        feePot = feePot.add(msg.value);\n', '    }\n', '\n', '\n', "    /// @notice Burn a REKT token. If applicable, fee reward and bounty are sent to user's pots.\n", '    /// REKT tokens can only be burned if the receiver has made gains >= the multiplier\n', '    /// (unless we are in shutdown mode).\n', '    /// @param _receiver The account that currently holds the REKT token.\n', '    function burn(address _receiver) external {\n', '        require(balanceOf(_receiver) == 1, "Nothing to burn");\n', '        address sender = receiver[_receiver].sender;\n', '        require(\n', '            msg.sender == _receiver ||\n', '            msg.sender == sender ||\n', '            (_receiver == address(this) && msg.sender == owner),\n', '            "Must be token sender or receiver, or must be the owner burning REKT sent to the contract"\n', '            );\n', '\n', '        if (!shutdown) {\n', '            if (receiver[_receiver].walletBalance.wmul(multiplier) > _receiver.balance) {\n', '                uint balanceValueThen = receiver[_receiver].walletBalance.wmul(receiver[_receiver].etherPrice);\n', '                uint balanceValueNow = _receiver.balance.wmul(getPrice());\n', '                if (balanceValueThen.wmul(multiplier) > balanceValueNow) {\n', '                    revert("Not enough gains");\n', '                }\n', '            }\n', '        }\n', '\n', '        balance[_receiver] = 0;\n', '        totalSupply --;\n', '        \n', '        emit Transfer(_receiver, address(0), 1);\n', '\n', '        uint feeReward = distributeBurnRewards(_receiver, sender);\n', '\n', '        emit LogBurn(\n', '            sender,\n', '            _receiver,\n', '            receiver[_receiver].timestamp,\n', '            multiplier,\n', '            receiver[_receiver].walletBalance,\n', '            receiver[_receiver].etherPrice,\n', '            receiver[_receiver].bountyETH,\n', '            receiver[_receiver].bountyDAI,\n', '            feeReward);\n', '    }\n', '\n', '\n', '    /// @notice Withdrawal of fee reward, DAI, SAI & ETH bounties for the user.\n', '    /// @param _addr The account to receive the funds and whose vault the funds will be taken from.\n', '    function withdraw(address payable _addr) external {\n', '        require(_addr != address(this), "This contract cannot withdraw to itself");\n', '        withdrawCommon(_addr, _addr);\n', '    }\n', '\n', '\n', "    /// @notice Withdraw from the contract's personal vault should anyone send\n", '    /// REKT to REKT.fyi with a bounty.\n', '    /// @param _destination The account to receive the funds.\n', '    function withdrawSelf(address payable _destination) external onlyOwner {\n', '        withdrawCommon(_destination, address(this));\n', '    }\n', '\n', '\n', '    /// @dev Sets a new Medianizer address in case of MakerDAO upgrades.\n', '    /// @param _addr The new address.\n', '    function setNewMedianizer(address _addr) external onlyOwner {\n', '        require(address(_addr) != address(0), "Invalid address");\n', '        medianizerAddress = _addr;\n', '        oracle = Medianizer(medianizerAddress);\n', '        bytes32 price;\n', '        bool ok;\n', '        (price, ok) = oracle.peek();\n', '        require(ok, "Pricefeed error");\n', '    }\n', '\n', '\n', '    /// @notice Sets a new DAI token address when MakerDAO upgrades to multicollateral DAI.\n', '    /// @dev DAI will now be deposited into vault[user].bountyDAI for new bounties instead\n', '    /// of vault[user].bountySAI.\n', '    /// If setMCD(address) has been included in the block already, then a user will\n', '    /// not be able to give a SAI/DAI bounty later in this block.\n', '    /// We can then determine with certainty whether they sent SAI or DAI when the time\n', "    /// comes to distribute it to a user's vault.\n", '    /// New DAI token can only be set once;\n', '    /// further changes will require shutdown and redeployment.\n', '    /// @param _addr The new address.\n', '    function setMCD(address _addr) external onlyOwner {\n', '        require(!isMCD, "MCD has already been set");\n', '        require(address(_addr) != address(0), "Invalid address");\n', '        daiAddress = _addr;\n', '        dai = Dai(daiAddress);\n', '        isMCD = true;\n', '        MCDswitchTimestamp = now;\n', '    }\n', '\n', '\n', '    /// @dev Sets a new bump price up to BUMP_PRICE_MAX.\n', '    /// @param _amount The base price of bumping by BUMP_INCREMENT.\n', '    function setBumpPrice(uint _amount) external onlyOwner {\n', '        require(_amount > 0 && _amount <= BUMP_PRICE_MAX, "Price must not be higher than BUMP_PRICE_MAX");\n', '        bumpBasePrice = _amount;\n', '    }\n', '\n', '\n', '    /// @dev Sets a new hold time ceiling up to HOLD_TIME_MAX.\n', '    /// @param _seconds The maximum hold time in seconds before the holdscore becomes 1 RAY.\n', '    function setHoldTimeCeiling(uint _seconds) external onlyOwner {\n', '        require(_seconds > 0 && _seconds <= HOLD_TIME_MAX, "Hold time must not be higher than HOLD_TIME_MAX");\n', '        holdTimeCeiling = _seconds;\n', '    }\n', '    \n', '\n', '    /// @dev Permanent shutdown of the contract.\n', '    /// No one can give or bump, everyone can burn and withdraw.\n', '    function setShutdown() external onlyOwner {\n', '        shutdown = true;\n', '    }\n', '\n', '\n', '    /**\n', '     * Public functions\n', '     */\n', '\n', '    /// @dev The proportion of the value of this bounty in relation to\n', '    /// the value of all bounties in the system.\n', '    /// @param _bounty This bounty.\n', '    /// @return A uint representing the proportion of bounty as a RAY.\n', '    function calculateBountyProportion(uint _bounty) public view returns (uint) {\n', '        return _bounty.rdiv(potValue(bountyPot.DAI, bountyPot.ETH));\n', '    }\n', '\n', '\n', '    /// @dev A score <= 1 RAY that corresponds to a duration between 0 and HOLD_SCORE_CEILING.\n', '    /// @params _receivedAtTime The timestamp of the block where the user received the REKT token.\n', '    /// @return A uint representing the score as a RAY.\n', '    function calculateHoldScore(uint _receivedAtTime) public view returns (uint) {\n', '        if (now == _receivedAtTime)\n', '        {\n', '            return 0;\n', '        }\n', '        uint timeDiff = now.sub(_receivedAtTime);\n', '        uint holdScore = timeDiff.rdiv(holdTimeCeiling);\n', '        if (holdScore > HOLD_SCORE_CEILING) {\n', '            holdScore = HOLD_SCORE_CEILING;\n', '        }\n', '        return holdScore;\n', '    }\n', '\n', '\n', '    /// @notice Returns the REKT balance of the specified address.\n', '    /// @dev Effectively a bool because the balance can only be 0 or 1.\n', '    /// @param _owner The address to query the balance of.\n', '    /// @return A uint representing the amount owned by the passed address.\n', '    function balanceOf(address _receiver) public view returns (uint) {\n', '        return balance[_receiver];\n', '    }\n', '\n', '\n', '    /// @notice Returns the total value of _dai and _eth in USD. 1 DAI = $1 is assumed.\n', "    /// @dev Price of ether taken from MakerDAO's Medianizer via getPrice().\n", '    /// @param _dai DAI to use in calculation.\n', '    /// @param _eth Ether to use in calculation.\n', '    /// @return A uint representing the total value of the inputs.\n', '    function potValue(uint _dai, uint _eth) public view returns (uint) {\n', '        return _dai.add(_eth.wmul(getPrice()));\n', '    }\n', '\n', '\n', '    /// @dev Returns the bonus multiplier represented as a WAD.\n', '    /// @param _sender The address of the sender.\n', '    /// @return A uint representing the bonus multiplier as a WAD.\n', '    function getBonusMultiplier(address _sender) public view returns (uint) {\n', '        uint bounty = potValue(unredeemedBounty[_sender].DAI, unredeemedBounty[_sender].ETH);\n', '        uint bonus = WAD;\n', '        if (bounty >= BOUNTY_BONUS_MINIMUM) {\n', '            bonus = bounty.wdiv(potValue(bountyPot.DAI, bountyPot.ETH)).add(BONUS_FLOOR);\n', '            if (bonus > BONUS_CEILING) {\n', '                bonus = BONUS_CEILING;\n', '            }\n', '        }\n', '        return bonus;\n', '    }\n', '\n', '\n', '    /// @dev Returns the addresses the sender has sent to as an array.\n', '    /// @param _sender The address of the sender.\n', '    /// @return An array of recipient addresses.\n', '    function getRecipients(address _sender) public view returns (address[] memory) {\n', '        return recipients[_sender];\n', '    }\n', '\n', '\n', '    /// @dev Returns the price of ETH in USD as per the MakerDAO Medianizer interface.\n', '    /// @return A uint representing the price of ETH in USD as a WAD.\n', '    function getPrice() public view returns (uint) {\n', '        bytes32 price;\n', '        bool ok;\n', '        (price, ok) = oracle.peek();\n', '        require(ok, "Pricefeed error");\n', '        return uint(price);\n', '    }\n', '\n', '\n', '    /**\n', '     * Private functions\n', '     */\n', '\n', '    /// @dev Common functionality for give(address) and giveWithDAI(address, uint).\n', '    /// @param _to The account to send the REKT token to.\n', '    function giveCommon(address _to) private {\n', '        balance[_to] = 1;\n', '        recipients[msg.sender].push(_to);\n', '        totalSupply ++;\n', '        emit Transfer(address(0), msg.sender, 1);\n', '        emit Transfer(msg.sender, _to, 1);\n', '        emit LogGive(msg.sender, _to);\n', '    }\n', '\n', '\n', '    /// @dev Assigns rewards and bounties to pots within user vaults dependant on holdScore\n', '    /// and bounty proportion compared to the total bounties within the system.\n', '    /// @param _receiver The account that received the REKT token.\n', '    /// @param _sender The account that sent the REKT token.\n', '    /// @return A uint representing the fee reward.\n', '    function distributeBurnRewards(address _receiver, address _sender) private returns (uint feeReward) {\n', '\n', '        feeReward = 0;\n', '\n', '        uint bountyETH = receiver[_receiver].bountyETH;\n', '        uint bountyDAI = receiver[_receiver].bountyDAI;\n', '        uint bountyTotal = potValue(bountyDAI, bountyETH);\n', '\n', '        if (bountyTotal > 0 ) {\n', '            uint bountyProportion = calculateBountyProportion(bountyTotal);\n', '            uint userRewardPot = bountyProportion.rmul(feePot);\n', '\n', '            if (shutdown) {\n', "                // in the shutdown state the holdscore isn't used\n", '                feeReward = userRewardPot;\n', '            } else {\n', '                uint holdScore = calculateHoldScore(receiver[_receiver].timestamp);\n', '                feeReward = userRewardPot.rmul(holdScore);\n', '            }\n', '\n', '            if (bountyETH > 0) {\n', "                // subtract bounty from the senders's bounty total and the bounty pot\n", '                unredeemedBounty[_sender].ETH = unredeemedBounty[_sender].ETH.sub(bountyETH);\n', '                bountyPot.ETH = bountyPot.ETH.sub(bountyETH);\n', '\n', '                // add bounty to receivers vault\n', '                vault[_receiver].bountyETH = vault[_receiver].bountyETH.add(bountyETH);\n', "                emit LogVaultDeposit(_receiver, 'bountyETH', bountyETH);\n", '\n', '            } else if (bountyDAI > 0) {\n', '                unredeemedBounty[_sender].DAI = unredeemedBounty[_sender].DAI.sub(bountyDAI);\n', '                bountyPot.DAI = bountyPot.DAI.sub(bountyDAI);\n', '                if (isMCD && receiver[_receiver].timestamp > MCDswitchTimestamp) {\n', '                    vault[_receiver].bountyDAI = vault[_receiver].bountyDAI.add(bountyDAI);\n', '                } else { // they would have sent SAI\n', '                    vault[_receiver].bountySAI = vault[_receiver].bountySAI.add(bountyDAI);\n', '                }\n', "                emit LogVaultDeposit(_receiver, 'bountyDAI', bountyDAI);\n", '            }\n', '\n', '            if (feeReward > 0) {\n', '                feeReward = feeReward / 2;\n', '\n', '                // subtract and add feeReward for receiver vault\n', '                feePot = feePot.sub(feeReward);\n', '                vault[_receiver].fee = vault[_receiver].fee.add(feeReward);\n', "                emit LogVaultDeposit(_receiver, 'reward', feeReward);\n", '\n', '                // subtract and add feeReward for sender vault\n', '                feePot = feePot.sub(feeReward);\n', '                vault[_sender].fee = vault[_sender].fee.add(feeReward);\n', "                emit LogVaultDeposit(_sender, 'reward', feeReward);\n", '            }\n', '        }\n', '\n', '        return feeReward;\n', '    }\n', '\n', '\n', '    /// @dev Returns a rounded bump amount represented as a WAD.\n', '    /// @param _amount The amount to be rounded.\n', '    /// @return A uint representing the amount rounded to PRECISION as a WAD.\n', '    function roundBumpAmount(uint _amount) private pure returns (uint rounded) {\n', '        require(_amount >= PRECISION, "bump size too small to round");\n', '        return (_amount / PRECISION).mul(PRECISION);\n', '    }\n', '\n', '\n', '    /// @dev called by withdraw(address) and withdrawSelf(address) to withdraw\n', '    /// fee reward, DAI, SAI & ETH bounties.\n', '    /// Both params will be the same for a normal user withdrawal.\n', '    /// @param _destination The account to receive the funds.\n', '    /// @param _vaultOwner The vault that the funds will be taken from.\n', '    function withdrawCommon(address payable _destination, address _vaultOwner) private {\n', '        require(address(_destination) != address(0), "Invalid address");\n', '        uint amountETH = vault[_vaultOwner].fee.add(vault[_vaultOwner].bountyETH);\n', '        uint amountDAI = vault[_vaultOwner].bountyDAI;\n', '        uint amountSAI = vault[_vaultOwner].bountySAI;\n', '        vault[_vaultOwner] = Vault(0,0,0,0);\n', '        emit LogWithdraw(_destination, amountETH, amountSAI, amountDAI);\n', '        if (amountDAI > 0) {\n', '            require(dai.transferFrom(address(this), _destination, amountDAI), "DAI transfer failed");\n', '        }\n', '        if (amountSAI > 0) {\n', '            require(sai.transferFrom(address(this), _destination, amountSAI), "SAI transfer failed");\n', '        }\n', '        if (amountETH > 0) {\n', '            _destination.transfer(amountETH);\n', '        }\n', '    }\n', '}']