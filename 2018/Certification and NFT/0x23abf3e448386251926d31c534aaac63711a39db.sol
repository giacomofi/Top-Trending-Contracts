['pragma solidity ^0.4.21;\n', '\n', '\n', '/**\n', ' * @title SafeMath\n', ' * @dev Math operations with safety checks that throw on error\n', ' */\n', 'library SafeMath {\n', '    function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        if (a == 0) {\n', '            return 0;\n', '        }\n', '        uint256 c = a * b;\n', '        require(c / a == b);\n', '        return c;\n', '    }\n', '    \n', '    function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        require(b > 0); // Solidity automatically throws when dividing by 0\n', '        uint256 c = a / b;\n', '        require(a == b * c + a % b); // There is no case in which this doesn&#39;t hold\n', '        return c;\n', '    }\n', '    \n', '    function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        require(b <= a);\n', '        return a - b;\n', '    }\n', '    \n', '    function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        uint256 c = a + b;\n', '        require(c >= a);\n', '        return c;\n', '    }\n', '}\n', '\n', '\n', '/**\n', ' * @title ERC20Basic\n', ' * @dev Simpler version of ERC20 interface\n', ' * @dev see https://github.com/ethereum/EIPs/issues/179\n', ' */\n', 'contract ERC20Basic {\n', '    uint256 public totalSupply;\n', '    function balanceOf(address who) public view returns (uint256);\n', '    function transfer(address to, uint256 value) public returns (bool);\n', '    event Transfer(address indexed from, address indexed to, uint256 value);\n', '}\n', '\n', '/**\n', ' * @title ERC20 interface\n', ' * @dev see https://github.com/ethereum/EIPs/issues/20\n', ' */\n', 'contract ERC20 is ERC20Basic {\n', '    function allowance(address owner, address spender) public view returns (uint256);\n', '    function transferFrom(address from, address to, uint256 value) public returns (bool);\n', '    function approve(address spender, uint256 value) public returns (bool);\n', '    event Approval(address indexed owner, address indexed spender, uint256 value);\n', '}\n', '\n', '\n', '/**\n', ' * @title BurnableCADVToken interface\n', ' * @dev see https://github.com/ethereum/EIPs/issues/20\n', ' */\n', 'contract BurnableCADVToken is ERC20 {\n', '\n', '    uint8 public decimals = 18;\n', '    string public name;\n', '    string public symbol;\n', '    \n', '    /**\n', '     * @dev set the amount of tokens that an owner allowed to a spender.\n', '     *  \n', '     * This function is disabled because using it is risky, so a revert()\n', '     * is always called as the first line of code.\n', '     * Instead of this function, use increaseApproval or decreaseApproval.\n', '     * \n', '     * @param _spender The address which will spend the funds.\n', '     * @param _value The amount of tokens to increase the allowance by.\n', '     */\n', '    function approve(address _spender, uint256 _value) public returns (bool) {\n', '        require(_spender != _spender);\n', '        require(_value != _value);\n', '        revert();\n', '    }\n', '    \n', '    function increaseApproval(address _spender, uint _addedValue) public returns (bool);\n', '    function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool);\n', '    function multipleTransfer(address[] _tos, uint256 _value) public returns (bool);\n', '    function burn(uint256 _value) public;\n', '    event Burn(address indexed burner, uint256 value);\n', '    \n', '}\n', '\n', '\n', '/**\n', ' * @title Ownable\n', ' * @dev The Ownable contract has an owner address, and provides basic authorization control\n', ' * functions, this simplifies the implementation of "user permissions".\n', ' */\n', 'contract Ownable {\n', '    address public owner;\n', '    \n', '    /**\n', '    * @dev The Ownable constructor sets the original `owner` of the contract to the sender\n', '    * account.\n', '    */\n', '    function Ownable() public {\n', '        owner = msg.sender;\n', '    }\n', '    \n', '    \n', '    /**\n', '    * @dev Throws if called by any account other than the owner.\n', '    */\n', '    modifier onlyOwner() {\n', '        require(msg.sender == owner);\n', '        _;\n', '    }\n', '    \n', '    \n', '    /**\n', '    * @dev Allows the current owner to transfer control of the contract to a newOwner.\n', '    * @param newOwner The address to transfer ownership to.\n', '    */\n', '    function transferOwnership(address newOwner) public onlyOwner {\n', '        require(newOwner != address(0));\n', '        emit OwnershipTransferred(owner, newOwner);\n', '        owner = newOwner;\n', '    }\n', '    \n', '    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);\n', '}\n', '\n', '\n', '/**\n', ' * @title Controlled CrowdSale\n', ' */\n', 'contract ControlledCrowdSale {\n', '    using SafeMath for uint256;\n', '    \n', '    mapping (address => uint256) public deposited;\n', '    mapping (address => bool) public unboundedLimit;\n', '    \n', '    uint256 public maxPerUser = 5 ether;\n', '    uint256 public minPerUser = 1 ether / 1000;\n', '    \n', '    \n', '    modifier controlledDonation() {\n', '        require(msg.value >= minPerUser);\n', '        deposited[msg.sender] = deposited[msg.sender].add(msg.value);\n', '        require(maxPerUser >= deposited[msg.sender] || unboundedLimit[msg.sender]);\n', '        _;\n', '    }\n', '\n', '}\n', '\n', '\n', '/**\n', ' * @title CoinAdvisorPreIco\n', ' * @dev This contract is used for storing funds while a crowdsale\n', ' * is in progress. Supports refunding the money if crowdsale fails,\n', ' * and forwarding it to a beneficiary if crowdsale is successful.\n', ' */\n', 'contract CoinAdvisorPreIco is Ownable, ControlledCrowdSale {\n', '    using SafeMath for uint256;\n', '    enum State { Active, Refunding, Completed }\n', '    \n', '    struct Phase {\n', '        uint expireDate;\n', '        uint256 maxAmount;\n', '        bool maxAmountEnabled;\n', '        uint rate;\n', '        bool locked;\n', '    }\n', '\n', '//=== properties =============================================\n', '    Phase[] public phases;\n', '    uint256 lastActivePhase;\n', '    State state;\n', '    uint256 public goal;\n', '    address public beneficiary;\n', '    BurnableCADVToken public token;\n', '    uint256 public refunduingStartDate;\n', '    \n', '//=== events ==================================================\n', '    event PreIcoClosed(string message, address crowdSaleClosed);\n', '    event RefundsEnabled();\n', '    event Refunded(address indexed beneficiary, uint256 weiAmount);\n', '    event PreIcoStarted(string message, address crowdSaleStarted);\n', '\n', '//=== constructor =============================================\n', '    function CoinAdvisorPreIco(address _beneficiary, address _token, uint256 _goal, uint256 _refunduingStartDate) public {\n', '        require(_beneficiary != address(0));\n', '        beneficiary = _beneficiary;\n', '        token = BurnableCADVToken(_token);\n', '        phases.push(Phase(0, 0, false, 0, false));\n', '        lastActivePhase = 0;\n', '        goal = _goal * 1 ether;\n', '        state = State.Active;\n', '        refunduingStartDate = _refunduingStartDate;\n', '    }\n', '\n', '\n', '    /**\n', '     * \n', '     *\n', '     */ \n', '    function isPhaseValid(uint256 index) public view returns (bool) {\n', '        return phases[index].expireDate >= now && (!phases[index].maxAmountEnabled || phases[index].maxAmount > minPerUser);\n', '    } \n', '    \n', '    \n', '    /**\n', '     * \n', '     *\n', '     */\n', '    function currentPhaseId() public view returns (uint256) {\n', '        uint256 index = lastActivePhase;\n', '        while(index < phases.length-1 && !isPhaseValid(index)) {\n', '            index = index +1;\n', '        }\n', '        return index;\n', '    }\n', '    \n', '    \n', '    /**\n', '     * \n', '     *\n', '     */\n', '    function addPhases(uint expireDate, uint256 maxAmount, bool maxAmountEnabled, uint rate, bool locked) onlyOwner public {\n', '        phases.push(Phase(expireDate, maxAmount, maxAmountEnabled, rate, locked));\n', '    }\n', '    \n', '    \n', '    /**\n', '     * \n', '     *\n', '     */\n', '    function resetPhases(uint expireDate, uint256 maxAmount, bool maxAmountEnabled, uint rate, bool locked) onlyOwner public {\n', '        require(!phases[currentPhaseId()].locked);\n', '        phases.length = 0;\n', '        lastActivePhase = 0;\n', '        addPhases(expireDate, maxAmount, maxAmountEnabled, rate, locked);\n', '    }\n', '    \n', '    \n', '    /**\n', '     * \n', '     *\n', '     */\n', '    function () controlledDonation public payable {\n', '        require(state != State.Refunding);\n', '        uint256 phaseId = currentPhaseId();\n', '        require(isPhaseValid(phaseId));\n', '        \n', '        if (phases[phaseId].maxAmountEnabled) {\n', '            if (phases[phaseId].maxAmount >= msg.value) {\n', '                phases[phaseId].maxAmount = phases[phaseId].maxAmount.sub(msg.value);\n', '            } else {\n', '                phases[phaseId].maxAmount = 0;\n', '                //throw;\n', '            }\n', '        }\n', '        \n', '        require(token.transfer(msg.sender, msg.value.mul(phases[phaseId].rate)));\n', '        lastActivePhase = phaseId;\n', '    }\n', '    \n', '    \n', '    /**\n', '     * \n', '     *\n', '     */\n', '    function retrieveFounds() onlyOwner public {\n', '        require(state == State.Completed || (state == State.Active && address(this).balance >= goal));\n', '        state = State.Completed;\n', '        beneficiary.transfer(address(this).balance);\n', '    }\n', '    \n', '    \n', '    /**\n', '     * \n', '     *\n', '     */\n', '    function startRefunding() public {\n', '        require(state == State.Active);\n', '        require(address(this).balance < goal);\n', '        require(refunduingStartDate < now);\n', '        state = State.Refunding;\n', '        emit RefundsEnabled();\n', '    }\n', '    \n', '    \n', '    /**\n', '     * \n', '     *\n', '     */\n', '    function forceRefunding() onlyOwner public {\n', '        require(state == State.Active);\n', '        state = State.Refunding;\n', '        emit RefundsEnabled();\n', '    }\n', '    \n', '    \n', '    /**\n', '     * \n', '     *\n', '     */\n', '    function refund(address investor) public {\n', '        require(state == State.Refunding);\n', '        require(deposited[investor] > 0);\n', '        \n', '        uint256 depositedValue = deposited[investor];\n', '        deposited[investor] = 0;\n', '        investor.transfer(depositedValue);\n', '        emit Refunded(investor, depositedValue);\n', '    }\n', '    \n', '    /**\n', '     * \n', '     *\n', '     */\n', '    function retrieveCadvsLeftInRefunding() onlyOwner public {\n', '        require(token.balanceOf(this) > 0);\n', '        require(token.transfer(beneficiary, token.balanceOf(this)));\n', '    }\n', '    \n', '    /**\n', '     * \n', '     *\n', '     */\n', '    function gameOver() onlyOwner public {\n', '        require(!isPhaseValid(currentPhaseId()));\n', '        require(state == State.Completed || (state == State.Active && address(this).balance >= goal));\n', '        require(token.transfer(beneficiary, token.balanceOf(this)));\n', '        selfdestruct(beneficiary);\n', '    }\n', '    \n', '    \n', '    /**\n', '     * \n', '     *\n', '     */\n', '    function setUnboundedLimit(address _investor, bool _state) onlyOwner public {\n', '        require(_investor != address(0));\n', '        unboundedLimit[_investor] = _state;\n', '    }\n', '\n', '    \n', '    function currentState() public view returns (string) {\n', '        if (state == State.Active) {\n', '            return "Active";\n', '        }\n', '        if (state == State.Completed) {\n', '            return "Completed";\n', '        }\n', '        if (state == State.Refunding) {\n', '            return "Refunding";\n', '        }\n', '    }\n', '    \n', '    \n', '    function tokensOnSale() public view returns (uint256) {\n', '        uint256 i = currentPhaseId();\n', '        if (isPhaseValid(i)) {\n', '            return phases[i].maxAmountEnabled ? phases[i].maxAmount : token.balanceOf(this);\n', '        } else {\n', '            return 0;\n', '        }\n', '    }\n', '\n', '    \n', '}']