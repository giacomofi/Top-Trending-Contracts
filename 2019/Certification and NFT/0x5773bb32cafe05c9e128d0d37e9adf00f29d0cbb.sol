['// File: openzeppelin-solidity/contracts/math/SafeMath.sol\n', '\n', 'pragma solidity ^0.4.24;\n', '\n', '\n', '/**\n', ' * @title SafeMath\n', ' * @dev Math operations with safety checks that throw on error\n', ' */\n', 'library SafeMath {\n', '\n', '  /**\n', '  * @dev Multiplies two numbers, throws on overflow.\n', '  */\n', '  function mul(uint256 _a, uint256 _b) internal pure returns (uint256 c) {\n', "    // Gas optimization: this is cheaper than asserting 'a' not being zero, but the\n", "    // benefit is lost if 'b' is also tested.\n", '    // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522\n', '    if (_a == 0) {\n', '      return 0;\n', '    }\n', '\n', '    c = _a * _b;\n', '    assert(c / _a == _b);\n', '    return c;\n', '  }\n', '\n', '  /**\n', '  * @dev Integer division of two numbers, truncating the quotient.\n', '  */\n', '  function div(uint256 _a, uint256 _b) internal pure returns (uint256) {\n', '    // assert(_b > 0); // Solidity automatically throws when dividing by 0\n', '    // uint256 c = _a / _b;\n', "    // assert(_a == _b * c + _a % _b); // There is no case in which this doesn't hold\n", '    return _a / _b;\n', '  }\n', '\n', '  /**\n', '  * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).\n', '  */\n', '  function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {\n', '    assert(_b <= _a);\n', '    return _a - _b;\n', '  }\n', '\n', '  /**\n', '  * @dev Adds two numbers, throws on overflow.\n', '  */\n', '  function add(uint256 _a, uint256 _b) internal pure returns (uint256 c) {\n', '    c = _a + _b;\n', '    assert(c >= _a);\n', '    return c;\n', '  }\n', '}\n', '\n', '// File: openzeppelin-solidity/contracts/ownership/Ownable.sol\n', '\n', 'pragma solidity ^0.4.24;\n', '\n', '\n', '/**\n', ' * @title Ownable\n', ' * @dev The Ownable contract has an owner address, and provides basic authorization control\n', ' * functions, this simplifies the implementation of "user permissions".\n', ' */\n', 'contract Ownable {\n', '  address public owner;\n', '\n', '\n', '  event OwnershipRenounced(address indexed previousOwner);\n', '  event OwnershipTransferred(\n', '    address indexed previousOwner,\n', '    address indexed newOwner\n', '  );\n', '\n', '\n', '  /**\n', '   * @dev The Ownable constructor sets the original `owner` of the contract to the sender\n', '   * account.\n', '   */\n', '  constructor() public {\n', '    owner = msg.sender;\n', '  }\n', '\n', '  /**\n', '   * @dev Throws if called by any account other than the owner.\n', '   */\n', '  modifier onlyOwner() {\n', '    require(msg.sender == owner);\n', '    _;\n', '  }\n', '\n', '  /**\n', '   * @dev Allows the current owner to relinquish control of the contract.\n', '   * @notice Renouncing to ownership will leave the contract without an owner.\n', '   * It will not be possible to call the functions with the `onlyOwner`\n', '   * modifier anymore.\n', '   */\n', '  function renounceOwnership() public onlyOwner {\n', '    emit OwnershipRenounced(owner);\n', '    owner = address(0);\n', '  }\n', '\n', '  /**\n', '   * @dev Allows the current owner to transfer control of the contract to a newOwner.\n', '   * @param _newOwner The address to transfer ownership to.\n', '   */\n', '  function transferOwnership(address _newOwner) public onlyOwner {\n', '    _transferOwnership(_newOwner);\n', '  }\n', '\n', '  /**\n', '   * @dev Transfers control of the contract to a newOwner.\n', '   * @param _newOwner The address to transfer ownership to.\n', '   */\n', '  function _transferOwnership(address _newOwner) internal {\n', '    require(_newOwner != address(0));\n', '    emit OwnershipTransferred(owner, _newOwner);\n', '    owner = _newOwner;\n', '  }\n', '}\n', '\n', '// File: openzeppelin-solidity/contracts/lifecycle/Pausable.sol\n', '\n', 'pragma solidity ^0.4.24;\n', '\n', '\n', '\n', '/**\n', ' * @title Pausable\n', ' * @dev Base contract which allows children to implement an emergency stop mechanism.\n', ' */\n', 'contract Pausable is Ownable {\n', '  event Pause();\n', '  event Unpause();\n', '\n', '  bool public paused = false;\n', '\n', '\n', '  /**\n', '   * @dev Modifier to make a function callable only when the contract is not paused.\n', '   */\n', '  modifier whenNotPaused() {\n', '    require(!paused);\n', '    _;\n', '  }\n', '\n', '  /**\n', '   * @dev Modifier to make a function callable only when the contract is paused.\n', '   */\n', '  modifier whenPaused() {\n', '    require(paused);\n', '    _;\n', '  }\n', '\n', '  /**\n', '   * @dev called by the owner to pause, triggers stopped state\n', '   */\n', '  function pause() public onlyOwner whenNotPaused {\n', '    paused = true;\n', '    emit Pause();\n', '  }\n', '\n', '  /**\n', '   * @dev called by the owner to unpause, returns to normal state\n', '   */\n', '  function unpause() public onlyOwner whenPaused {\n', '    paused = false;\n', '    emit Unpause();\n', '  }\n', '}\n', '\n', '// File: openzeppelin-solidity/contracts/token/ERC20/ERC20Basic.sol\n', '\n', 'pragma solidity ^0.4.24;\n', '\n', '\n', '/**\n', ' * @title ERC20Basic\n', ' * @dev Simpler version of ERC20 interface\n', ' * See https://github.com/ethereum/EIPs/issues/179\n', ' */\n', 'contract ERC20Basic {\n', '  function totalSupply() public view returns (uint256);\n', '  function balanceOf(address _who) public view returns (uint256);\n', '  function transfer(address _to, uint256 _value) public returns (bool);\n', '  event Transfer(address indexed from, address indexed to, uint256 value);\n', '}\n', '\n', '// File: openzeppelin-solidity/contracts/token/ERC20/ERC20.sol\n', '\n', 'pragma solidity ^0.4.24;\n', '\n', '\n', '\n', '/**\n', ' * @title ERC20 interface\n', ' * @dev see https://github.com/ethereum/EIPs/issues/20\n', ' */\n', 'contract ERC20 is ERC20Basic {\n', '  function allowance(address _owner, address _spender)\n', '    public view returns (uint256);\n', '\n', '  function transferFrom(address _from, address _to, uint256 _value)\n', '    public returns (bool);\n', '\n', '  function approve(address _spender, uint256 _value) public returns (bool);\n', '  event Approval(\n', '    address indexed owner,\n', '    address indexed spender,\n', '    uint256 value\n', '  );\n', '}\n', '\n', '// File: openzeppelin-solidity/contracts/token/ERC20/SafeERC20.sol\n', '\n', 'pragma solidity ^0.4.24;\n', '\n', '\n', '\n', '\n', '/**\n', ' * @title SafeERC20\n', ' * @dev Wrappers around ERC20 operations that throw on failure.\n', ' * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,\n', ' * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.\n', ' */\n', 'library SafeERC20 {\n', '  function safeTransfer(\n', '    ERC20Basic _token,\n', '    address _to,\n', '    uint256 _value\n', '  )\n', '    internal\n', '  {\n', '    require(_token.transfer(_to, _value));\n', '  }\n', '\n', '  function safeTransferFrom(\n', '    ERC20 _token,\n', '    address _from,\n', '    address _to,\n', '    uint256 _value\n', '  )\n', '    internal\n', '  {\n', '    require(_token.transferFrom(_from, _to, _value));\n', '  }\n', '\n', '  function safeApprove(\n', '    ERC20 _token,\n', '    address _spender,\n', '    uint256 _value\n', '  )\n', '    internal\n', '  {\n', '    require(_token.approve(_spender, _value));\n', '  }\n', '}\n', '\n', '// File: monetha-utility-contracts/contracts/Restricted.sol\n', '\n', 'pragma solidity ^0.4.18;\n', '\n', '\n', '\n', '/** @title Restricted\n', ' *  Exposes onlyMonetha modifier\n', ' */\n', 'contract Restricted is Ownable {\n', '\n', '    //MonethaAddress set event\n', '    event MonethaAddressSet(\n', '        address _address,\n', '        bool _isMonethaAddress\n', '    );\n', '\n', '    mapping (address => bool) public isMonethaAddress;\n', '\n', '    /**\n', '     *  Restrict methods in such way, that they can be invoked only by monethaAddress account.\n', '     */\n', '    modifier onlyMonetha() {\n', '        require(isMonethaAddress[msg.sender]);\n', '        _;\n', '    }\n', '\n', '    /**\n', '     *  Allows owner to set new monetha address\n', '     */\n', '    function setMonethaAddress(address _address, bool _isMonethaAddress) onlyOwner public {\n', '        isMonethaAddress[_address] = _isMonethaAddress;\n', '\n', '        emit MonethaAddressSet(_address, _isMonethaAddress);\n', '    }\n', '}\n', '\n', '// File: monetha-utility-contracts/contracts/ownership/CanReclaimEther.sol\n', '\n', 'pragma solidity ^0.4.24;\n', '\n', '\n', 'contract CanReclaimEther is Ownable {\n', '    event ReclaimEther(address indexed to, uint256 amount);\n', '\n', '    /**\n', '     * @dev Transfer all Ether held by the contract to the owner.\n', '     */\n', '    function reclaimEther() external onlyOwner {\n', '        uint256 value = address(this).balance;\n', '        owner.transfer(value);\n', '\n', '        emit ReclaimEther(owner, value);\n', '    }\n', '\n', '    /**\n', '     * @dev Transfer specified amount of Ether held by the contract to the address.\n', '     * @param _to The address which will receive the Ether\n', '     * @param _value The amount of Ether to transfer\n', '     */\n', '    function reclaimEtherTo(address _to, uint256 _value) external onlyOwner {\n', '        require(_to != address(0), "zero address is not allowed");\n', '        _to.transfer(_value);\n', '\n', '        emit ReclaimEther(_to, _value);\n', '    }\n', '}\n', '\n', '// File: monetha-utility-contracts/contracts/ownership/CanReclaimTokens.sol\n', '\n', 'pragma solidity ^0.4.24;\n', '\n', '\n', '\n', '\n', 'contract CanReclaimTokens is Ownable {\n', '    using SafeERC20 for ERC20Basic;\n', '\n', '    event ReclaimTokens(address indexed to, uint256 amount);\n', '\n', '    /**\n', '     * @dev Reclaim all ERC20Basic compatible tokens\n', '     * @param _token ERC20Basic The address of the token contract\n', '     */\n', '    function reclaimToken(ERC20Basic _token) external onlyOwner {\n', '        uint256 balance = _token.balanceOf(this);\n', '        _token.safeTransfer(owner, balance);\n', '\n', '        emit ReclaimTokens(owner, balance);\n', '    }\n', '\n', '    /**\n', '     * @dev Reclaim specified amount of ERC20Basic compatible tokens\n', '     * @param _token ERC20Basic The address of the token contract\n', '     * @param _to The address which will receive the tokens\n', '     * @param _value The amount of tokens to transfer\n', '     */\n', '    function reclaimTokenTo(ERC20Basic _token, address _to, uint256 _value) external onlyOwner {\n', '        require(_to != address(0), "zero address is not allowed");\n', '        _token.safeTransfer(_to, _value);\n', '\n', '        emit ReclaimTokens(_to, _value);\n', '    }\n', '}\n', '\n', '// File: contracts/MonethaClaimHandler.sol\n', '\n', 'pragma solidity ^0.4.24;\n', '\n', '\n', '\n', '\n', '\n', '\n', '\n', '\n', '\n', '/**\n', ' *  @title MonethaClaimHandler\n', ' *\n', ' *  MonethaClaimHandler handles claim creation, acceptance, resolution and confirmation.\n', ' */\n', 'contract MonethaClaimHandler is Restricted, Pausable, CanReclaimEther, CanReclaimTokens {\n', '    using SafeMath for uint256;\n', '    using SafeERC20 for ERC20;\n', '    using SafeERC20 for ERC20Basic;\n', '\n', '    event MinStakeUpdated(uint256 previousMinStake, uint256 newMinStake);\n', '\n', '    event ClaimCreated(uint256 indexed dealId, uint256 indexed claimIdx);\n', '    event ClaimAccepted(uint256 indexed dealId, uint256 indexed claimIdx);\n', '    event ClaimResolved(uint256 indexed dealId, uint256 indexed claimIdx);\n', '    event ClaimClosedAfterAcceptanceExpired(uint256 indexed dealId, uint256 indexed claimIdx);\n', '    event ClaimClosedAfterResolutionExpired(uint256 indexed dealId, uint256 indexed claimIdx);\n', '    event ClaimClosedAfterConfirmationExpired(uint256 indexed dealId, uint256 indexed claimIdx);\n', '    event ClaimClosed(uint256 indexed dealId, uint256 indexed claimIdx);\n', '\n', '    ERC20 public token;      // token contract address\n', '    uint256 public minStake; // minimum amount of token units to create and accept claim\n', '\n', '    // State of claim\n', '    enum State {\n', '        Null,\n', '        AwaitingAcceptance,\n', '        AwaitingResolution,\n', '        AwaitingConfirmation,\n', '        ClosedAfterAcceptanceExpired,\n', '        ClosedAfterResolutionExpired,\n', '        ClosedAfterConfirmationExpired,\n', '        Closed\n', '    }\n', '\n', '    struct Claim {\n', '        State state;\n', '        uint256 modified;\n', '        uint256 dealId; // immutable after AwaitingAcceptance\n', '        bytes32 dealHash; // immutable after AwaitingAcceptance\n', '        string reasonNote; // immutable after AwaitingAcceptance\n', '        bytes32 requesterId; // immutable after AwaitingAcceptance\n', '        address requesterAddress; // immutable after AwaitingAcceptance\n', '        uint256 requesterStaked; // immutable after AwaitingAcceptance\n', '        bytes32 respondentId; // immutable after AwaitingAcceptance\n', '        address respondentAddress; // immutable after Accepted\n', '        uint256 respondentStaked; // immutable after Accepted\n', '        string resolutionNote; // immutable after Resolved\n', '    }\n', '\n', '    Claim[] public claims;\n', '\n', '    constructor(ERC20 _token, uint256 _minStake) public {\n', '        require(_token != address(0), "must be valid token address");\n', '\n', '        token = _token;\n', '        _setMinStake(_minStake);\n', '    }\n', '\n', '    /**\n', '     * @dev sets the minimum amount of tokens units to stake when creating or accepting the claim.\n', '     * Only Monetha account allowed to call this method.\n', '     */\n', '    function setMinStake(uint256 _newMinStake) external whenNotPaused onlyMonetha {\n', '        _setMinStake(_newMinStake);\n', '    }\n', '\n', '    /**\n', '     * @dev returns the number of claims created.\n', '     */\n', '    function getClaimsCount() public constant returns (uint256 count) {\n', '        return claims.length;\n', '    }\n', '\n', '    /**\n', '    * @dev creates new claim using provided parameters. Before calling this method, requester should approve\n', '    * this contract to transfer min. amount of token units in their behalf, by calling\n', '    * `approve(address _spender, uint _value)` method of token contract.\n', '    * Respondent should accept the claim by calling accept() method.\n', '    * claimIdx should be extracted from ClaimCreated event.\n', '    *\n', '    * Claim state after call 🡒 AwaitingAcceptance\n', '    */\n', '    function create(\n', '        uint256 _dealId,\n', '        bytes32 _dealHash,\n', '        string _reasonNote,\n', '        bytes32 _requesterId,\n', '        bytes32 _respondentId,\n', '        uint256 _amountToStake\n', '    ) external whenNotPaused {\n', '        require(bytes(_reasonNote).length > 0, "reason note must not be empty");\n', '        require(_dealHash != bytes32(0), "deal hash must be non-zero");\n', '        require(_requesterId != bytes32(0), "requester ID must be non-zero");\n', '        require(_respondentId != bytes32(0), "respondent ID must be non-zero");\n', '        require(keccak256(abi.encodePacked(_requesterId)) != keccak256(abi.encodePacked(_respondentId)),\n', '            "requester and respondent must be different");\n', '        require(_amountToStake >= minStake, "amount to stake must be greater or equal to min.stake");\n', '\n', '        uint256 requesterAllowance = token.allowance(msg.sender, address(this));\n', '        require(requesterAllowance >= _amountToStake, "allowance too small");\n', '        token.safeTransferFrom(msg.sender, address(this), _amountToStake);\n', '\n', '        Claim memory claim = Claim({\n', '            state : State.AwaitingAcceptance,\n', '            modified : now,\n', '            dealId : _dealId,\n', '            dealHash : _dealHash,\n', '            reasonNote : _reasonNote,\n', '            requesterId : _requesterId,\n', '            requesterAddress : msg.sender,\n', '            requesterStaked : _amountToStake,\n', '            respondentId : _respondentId,\n', '            respondentAddress : address(0),\n', '            respondentStaked : 0,\n', '            resolutionNote : ""\n', '            });\n', '        claims.push(claim);\n', '\n', '        emit ClaimCreated(_dealId, claims.length - 1);\n', '    }\n', '\n', '    /**\n', '     * @dev accepts the claim by respondent. Before calling this method, respondent should approve\n', '     * this contract to transfer min. amount of token units in their behalf, by calling\n', '     * `approve(address _spender, uint _value)` method of token contract. Respondent must stake the same amount\n', '     * of tokens as requester.\n', '     *\n', '     * Claim state after call 🡒 AwaitingResolution (if was AwaitingAcceptance)\n', '     */\n', '    function accept(uint256 _claimIdx) external whenNotPaused {\n', '        require(_claimIdx < claims.length, "invalid claim index");\n', '        Claim storage claim = claims[_claimIdx];\n', '        require(State.AwaitingAcceptance == claim.state, "State.AwaitingAcceptance required");\n', '        require(msg.sender != claim.requesterAddress, "requester and respondent addresses must be different");\n', '\n', '        uint256 requesterStaked = claim.requesterStaked;\n', '        token.safeTransferFrom(msg.sender, address(this), requesterStaked);\n', '\n', '        claim.state = State.AwaitingResolution;\n', '        claim.modified = now;\n', '        claim.respondentAddress = msg.sender;\n', '        claim.respondentStaked = requesterStaked;\n', '\n', '        emit ClaimAccepted(claim.dealId, _claimIdx);\n', '    }\n', '\n', '    /**\n', '     * @dev resolves the claim by respondent. Respondent will get staked amount of tokens back.\n', '     *\n', '     * Claim state after call 🡒 AwaitingConfirmation (if was AwaitingResolution)\n', '     */\n', '    function resolve(uint256 _claimIdx, string _resolutionNote) external whenNotPaused {\n', '        require(_claimIdx < claims.length, "invalid claim index");\n', '        require(bytes(_resolutionNote).length > 0, "resolution note must not be empty");\n', '        Claim storage claim = claims[_claimIdx];\n', '        require(State.AwaitingResolution == claim.state, "State.AwaitingResolution required");\n', '        require(msg.sender == claim.respondentAddress, "awaiting respondent");\n', '\n', '        uint256 respStakedBefore = claim.respondentStaked;\n', '\n', '        claim.state = State.AwaitingConfirmation;\n', '        claim.modified = now;\n', '        claim.respondentStaked = 0;\n', '        claim.resolutionNote = _resolutionNote;\n', '\n', '        token.safeTransfer(msg.sender, respStakedBefore);\n', '\n', '        emit ClaimResolved(claim.dealId, _claimIdx);\n', '    }\n', '\n', '    /**\n', '     * @dev closes the claim by requester.\n', '     * Requester allowed to call this method 72 hours after call to create() or accept(), and immediately after resolve().\n', '     * Requester will get staked amount of tokens back. Requester will also get the respondent’s tokens if\n', '     * the respondent did not call the resolve() method within 72 hours.\n', '     *\n', '     * Claim state after call 🡒 Closed                         (if was AwaitingConfirmation, and less than 24 hours passed)\n', '     *                        🡒 ClosedAfterConfirmationExpired (if was AwaitingConfirmation, after 24 hours)\n', '     *                        🡒 ClosedAfterAcceptanceExpired   (if was AwaitingAcceptance, after 72 hours)\n', '     *                        🡒 ClosedAfterResolutionExpired   (if was AwaitingResolution, after 72 hours)\n', '     */\n', '    function close(uint256 _claimIdx) external whenNotPaused {\n', '        require(_claimIdx < claims.length, "invalid claim index");\n', '        State state = claims[_claimIdx].state;\n', '\n', '        if (State.AwaitingAcceptance == state) {\n', '            return _closeAfterAwaitingAcceptance(_claimIdx);\n', '        } else if (State.AwaitingResolution == state) {\n', '            return _closeAfterAwaitingResolution(_claimIdx);\n', '        } else if (State.AwaitingConfirmation == state) {\n', '            return _closeAfterAwaitingConfirmation(_claimIdx);\n', '        }\n', '\n', '        revert("claim.State");\n', '    }\n', '\n', '    function _closeAfterAwaitingAcceptance(uint256 _claimIdx) internal {\n', '        Claim storage claim = claims[_claimIdx];\n', '        require(msg.sender == claim.requesterAddress, "awaiting requester");\n', '        require(State.AwaitingAcceptance == claim.state, "State.AwaitingAcceptance required");\n', '        require(_hoursPassed(claim.modified, 72), "expiration required");\n', '\n', '        uint256 stakedBefore = claim.requesterStaked;\n', '\n', '        claim.state = State.ClosedAfterAcceptanceExpired;\n', '        claim.modified = now;\n', '        claim.requesterStaked = 0;\n', '\n', '        token.safeTransfer(msg.sender, stakedBefore);\n', '\n', '        emit ClaimClosedAfterAcceptanceExpired(claim.dealId, _claimIdx);\n', '    }\n', '\n', '    function _closeAfterAwaitingResolution(uint256 _claimIdx) internal {\n', '        Claim storage claim = claims[_claimIdx];\n', '        require(State.AwaitingResolution == claim.state, "State.AwaitingResolution required");\n', '        require(_hoursPassed(claim.modified, 72), "expiration required");\n', '        require(msg.sender == claim.requesterAddress, "awaiting requester");\n', '\n', '        uint256 totalStaked = claim.requesterStaked.add(claim.respondentStaked);\n', '\n', '        claim.state = State.ClosedAfterResolutionExpired;\n', '        claim.modified = now;\n', '        claim.requesterStaked = 0;\n', '        claim.respondentStaked = 0;\n', '\n', '        token.safeTransfer(msg.sender, totalStaked);\n', '\n', '        emit ClaimClosedAfterResolutionExpired(claim.dealId, _claimIdx);\n', '    }\n', '\n', '    function _closeAfterAwaitingConfirmation(uint256 _claimIdx) internal {\n', '        Claim storage claim = claims[_claimIdx];\n', '        require(msg.sender == claim.requesterAddress, "awaiting requester");\n', '        require(State.AwaitingConfirmation == claim.state, "State.AwaitingConfirmation required");\n', '\n', '        bool expired = _hoursPassed(claim.modified, 24);\n', '        if (expired) {\n', '            claim.state = State.ClosedAfterConfirmationExpired;\n', '        } else {\n', '            claim.state = State.Closed;\n', '        }\n', '        claim.modified = now;\n', '\n', '        uint256 stakedBefore = claim.requesterStaked;\n', '        claim.requesterStaked = 0;\n', '\n', '        token.safeTransfer(msg.sender, stakedBefore);\n', '\n', '        if (expired) {\n', '            emit ClaimClosedAfterConfirmationExpired(claim.dealId, _claimIdx);\n', '        } else {\n', '            emit ClaimClosed(claim.dealId, _claimIdx);\n', '        }\n', '    }\n', '\n', '    function _hoursPassed(uint256 start, uint256 hoursAfter) internal view returns (bool) {\n', '        return now >= start + hoursAfter * 1 hours;\n', '    }\n', '\n', '    function _setMinStake(uint256 _newMinStake) internal {\n', '        uint256 previousMinStake = minStake;\n', '        if (previousMinStake != _newMinStake) {\n', '            emit MinStakeUpdated(previousMinStake, _newMinStake);\n', '            minStake = _newMinStake;\n', '        }\n', '    }\n', '}']