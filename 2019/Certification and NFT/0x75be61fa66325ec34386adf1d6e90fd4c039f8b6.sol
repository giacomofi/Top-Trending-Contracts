['pragma solidity 0.5.0;\n', '\n', '\n', '// ----------------------------------------------------------------------------\n', '// ERC Token Standard #20 Interface\n', '// https://github.com/OpenZeppelin/zeppelin-solidity/blob/master/contracts/token/ERC20/ERC20.sol\n', '// https://github.com/OpenZeppelin/zeppelin-solidity/blob/master/contracts/token/ERC20/ERC20Basic.sol\n', '// \n', '// ----------------------------------------------------------------------------\n', 'contract ERC20Interface {\n', '    function totalSupply() public view returns (uint256);\n', '    function balanceOf(address who) public view returns (uint256);\n', '    function allowance(address approver, address spender) public view returns (uint256);\n', '    function transfer(address to, uint256 value) public returns (bool);\n', '    function approve(address spender, uint256 value) public returns (bool);\n', '    function transferFrom(address from, address to, uint256 value) public returns (bool);\n', '\n', '    // solhint-disable-next-line no-simple-event-func-name\n', '    event Transfer(address indexed from, address indexed to, uint256 value);\n', '    event Approval(address indexed approver, address indexed spender, uint256 value);\n', '}\n', '\n', '\n', '\n', '//\n', '// base contract for all our horizon contracts and tokens\n', '//\n', 'contract HorizonContractBase {\n', '    // The owner of the contract, set at contract creation to the creator.\n', '    address public owner;\n', '\n', '    constructor() public {\n', '        owner = msg.sender;\n', '    }\n', '\n', '    // Contract authorization - only allow the owner to perform certain actions.\n', '    modifier onlyOwner {\n', '        require(msg.sender == owner, "Only the owner can call this function.");\n', '        _;\n', '    }\n', '}\n', '\n', '\n', '\n', '//\n', '// Base contract that includes authorisation restrictions.\n', '//\n', 'contract AuthorisedContractBase is HorizonContractBase {\n', '\n', '    /**\n', '     * @notice The list of addresses that are allowed restricted privileges.\n', '     */\n', '    mapping(address => bool) public authorised;\n', '\n', '    /**\n', "     * @notice Notify interested parties when an account's status changes.\n", '     */\n', '    event AuthorisationChanged(address indexed who, bool isAuthorised);\n', '\n', '    /**\n', '     * @notice Sole constructor.  Add the owner to the authorised whitelist.\n', '     */\n', '    constructor() public {\n', '        // The contract owner is always authorised.\n', '        setAuthorised(msg.sender, true);\n', '    } \n', '\n', '    /**\n', '     * @notice Add or remove special privileges.\n', '     *\n', '     * @param who           The address of the contract.\n', '     * @param isAuthorised  Whether special privileges are allowed or not.\n', '     */\n', '    function setAuthorised(address who, bool isAuthorised) public onlyOwner {\n', '        authorised[who] = isAuthorised;\n', '        emit AuthorisationChanged(who, isAuthorised);\n', '    }\n', '\n', '    /**\n', '     * Whether the specified address has special privileges or not.\n', '     *\n', '     * @param who       The address of the contract.\n', '     * @return True if address has special privileges, false otherwise.\n', '     */\n', '    function isAuthorised(address who) public view returns (bool) {\n', '        return authorised[who];\n', '    }\n', '\n', '    /**\n', '     * @notice Restrict access to anyone nominated by the owner.\n', '     */\n', '    modifier onlyAuthorised() {\n', '        require(isAuthorised(msg.sender), "Access denied.");\n', '        _;\n', '    }\n', '}\n', '\n', ' \n', '\n', '/**\n', ' * @title SafeMath\n', ' * @dev Math operations with safety checks that throw on error\n', ' *\n', ' * Source: https://github.com/OpenZeppelin/zeppelin-solidity/blob/master/contracts/math/SafeMath.sol\n', ' */\n', 'library SafeMath {\n', '    /**\n', '     * @dev Multiplies two numbers, throws on overflow.\n', '     */\n', '    function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        if (a == 0) {\n', '            return 0;\n', '        }\n', '        uint256 c = a * b;\n', '        assert(c / a == b);\n', '        return c;\n', '    }\n', '\n', '    /**\n', '    * @dev Integer division of two numbers, truncating the quotient.\n', '    */\n', '    function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '        // uint256 c = a / b;\n', "        // assert(a == b * c + a % b); // There is no case in which this doesn't hold\n", '        return a / b;\n', '    }\n', '\n', '    /**\n', '    * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).\n', '    */\n', '    function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        assert(b <= a);\n', '        return a - b;\n', '    }\n', '\n', '    /**\n', '    * @dev Adds two numbers, throws on overflow.\n', '    */\n', '    function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        uint256 c = a + b;\n', '        assert(c >= a);\n', '        return c;\n', '    }\n', '}\n', '\n', '/**\n', ' * VOXToken for the Talketh.io ICO by Horizon-Globex.com of Switzerland.\n', ' *\n', ' * An ERC20 standard\n', ' *\n', ' * Author: Horizon Globex GmbH Development Team\n', ' *\n', ' * Dev Notes\n', ' *   NOTE: There is no fallback function as this contract will never contain Ether, only the VOX tokens.\n', ' *   NOTE: There is no approveAndCall/receiveApproval or ERC223 functionality.\n', ' *   NOTE: Coins will never be minted beyond those at contract creation.\n', " *   NOTE: Zero transfers are allowed - we don't want to break a valid transaction chain.\n", ' *   NOTE: There is no selfDestruct, changeOwner or migration path - this is the only contract.\n', ' */\n', '\n', '\n', 'contract VOXToken is ERC20Interface, AuthorisedContractBase {\n', '    using SafeMath for uint256;\n', '\n', '    // Contract authorization - only allow the official KYC provider to perform certain actions.\n', '    modifier onlyKycProvider {\n', '        require(msg.sender == regulatorApprovedKycProvider, "Only the KYC Provider can call this function.");\n', '        _;\n', '    }\n', '\n', '    // The approved KYC provider that verifies all ICO/TGE Contributors.\n', '    address public regulatorApprovedKycProvider;\n', '\n', '    // Public identity variables of the token used by ERC20 platforms.\n', '    string public name = "Talketh";\n', '    string public symbol = "VOX";\n', '    \n', '    // There is no good reason to deviate from 18 decimals, see https://github.com/ethereum/EIPs/issues/724.\n', '    uint8 public decimals = 18;\n', '    \n', '    // The total supply of tokens, set at creation, decreased with burn.\n', '    uint256 public totalSupply_;\n', '\n', '    // The supply of tokens, set at creation, to be allocated for the referral bonuses.\n', '    uint256 public rewardPool_;\n', '\n', '    // The Initial Coin Offering is finished.\n', '    bool public isIcoComplete;\n', '\n', '    // The balances of all accounts.\n', '    mapping (address => uint256) public balances;\n', '\n', '    // KYC submission hashes accepted by KYC service provider for AML/KYC review.\n', '    bytes32[] public kycHashes;\n', '\n', "    // Addresses authorized to transfer tokens on an account's behalf.\n", '    mapping (address => mapping (address => uint256)) internal allowanceCollection;\n', '\n', '    // Lookup an ICO/TGE Contributor address to see if it was referred by another address (referee => referrer).\n', '    mapping (address => address) public referredBy;\n', '\n', '    // Emitted when the Initial Coin Offering phase ends, see closeIco().\n', '    event IcoComplete();\n', '\n', '    // Notification when tokens are burned by the owner.\n', '    event Burn(address indexed from, uint256 value);\n', '\n', '    // Someone who was referred has purchased tokens, when the bonus is awarded log the details.\n', '    event ReferralRedeemed(address indexed referrer, address indexed referee, uint256 value);\n', '\n', '    /**\n', '     * Initialise contract with the 50 million initial supply tokens, allocated to\n', '     * the creator of the contract (the owner).\n', '     */\n', '    constructor() public {\n', '        setAuthorised(msg.sender, true);                    // The owner is always approved.\n', '\n', '        totalSupply_ = 50000000 * 10 ** uint256(decimals);   // Set the total supply of VOX Tokens.\n', '        balances[msg.sender] = totalSupply_;\n', '        rewardPool_ = 375000 * 10 ** uint256(decimals);   // Set the total supply of VOX Reward Tokens.\n', '    }\n', '\n', '    /**\n', '     * The total number of tokens that exist.\n', '     */\n', '    function totalSupply() public view returns (uint256) {\n', '        return totalSupply_;\n', '    }\n', '\n', '    /**\n', '     * The total number of reward pool tokens that remains.\n', '     */\n', '    function rewardPool() public onlyOwner view returns (uint256) {\n', '        return rewardPool_;\n', '    }\n', '\n', '    /**\n', '     * Get the number of tokens for a specific account.\n', '     *\n', '     * @param who    The address to get the token balance of.\n', '     */\n', '    function balanceOf(address who) public view returns (uint256 balance) {\n', '        return balances[who];\n', '    }\n', '\n', '    /**\n', "     * Get the current allowanceCollection that the approver has allowed 'spender' to spend on their behalf.\n", '     *\n', '     * See also: approve() and transferFrom().\n', '     *\n', '     * @param _approver  The account that owns the tokens.\n', "     * @param _spender   The account that can spend the approver's tokens.\n", '     */\n', '    function allowance(address _approver, address _spender) public view returns (uint256) {\n', '        return allowanceCollection[_approver][_spender];\n', '    }\n', '\n', '    /**\n', '     * Add the link between the referrer and who they referred.\n', '     *\n', '     * ---- ICO-Platform Note ----\n', '     * The horizon-globex.com ICO platform offers functionality for referrers to sign-up\n', '     * to refer Contributors. Upon such referred Contributions, Company shall automatically\n', '     * award 1% of our "owner" VOX tokens to the referrer as coded by this Smart Contract.\n', '     *\n', '     * All referrers must successfully complete our ICO KYC review prior to being allowed on-board.\n', '     * -- End ICO-Platform Note --\n', '     *\n', '     * @param referrer  The person doing the referring.\n', '     * @param referee   The person that was referred.\n', '     */\n', '    function refer(address referrer, address referee) public onlyOwner {\n', '        require(referrer != address(0x0), "Referrer cannot be null");\n', '        require(referee != address(0x0), "Referee cannot be null");\n', '        require(!isIcoComplete, "Cannot add new referrals after ICO is complete.");\n', '\n', '        referredBy[referee] = referrer;\n', '    }\n', '\n', '    /**\n', "     * Transfer tokens from the caller's account to the recipient.\n", '     *\n', '     * @param to    The address of the recipient.\n', '     * @param value The number of tokens to send.\n', '     */\n', '    // solhint-disable-next-line no-simple-event-func-name\n', '    function transfer(address to, uint256 value) public returns (bool) {\n', '        return _transfer(msg.sender, to, value);\n', '    }\n', '\t\n', '    /**\n', '     * Transfer pre-approved tokens on behalf of an account.\n', '     *\n', '     * See also: approve() and allowance().\n', '     *\n', '     * @param from  The address of the sender\n', '     * @param to    The address of the recipient\n', '     * @param value The number of tokens to send\n', '     */\n', '    function transferFrom(address from, address to, uint256 value) public returns (bool) {\n', '        require(value <= allowanceCollection[from][msg.sender], "Amount to transfer is greater than allowance.");\n', '\t\t\n', '        allowanceCollection[from][msg.sender] = allowanceCollection[from][msg.sender].sub(value);\n', '        _transfer(from, to, value);\n', '        return true;\n', '    }\n', '\n', '    /**\n', '     * Allow another address to spend tokens on your behalf.\n', '     *\n', '     * transferFrom can be called multiple times until the approved balance goes to zero.\n', '     * Subsequent calls to this function overwrite the previous balance.\n', '     * To change from a non-zero value to another non-zero value you must first set the\n', '     * allowance to zero - it is best to use safeApprove when doing this as you will\n', '     * manually have to check for transfers to ensure none happened before the zero allowance\n', '     * was set.\n', '     *\n', '     * @param _spender   The address authorized to spend your tokens.\n', '     * @param _value     The maximum amount of tokens they can spend.\n', '     */\n', '    function approve(address _spender, uint256 _value) public returns (bool) {\n', '        require(isAuthorised(_spender), "Target of approve has not passed KYC");\n', '        if(allowanceCollection[msg.sender][_spender] > 0 && _value != 0) {\n', '            revert("You cannot set a non-zero allowance to another non-zero, you must zero it first.");\n', '        }\n', '\n', '        allowanceCollection[msg.sender][_spender] = _value;\n', '        emit Approval(msg.sender, _spender, _value);\n', '\n', '        return true;\n', '    }\n', '\n', '    /**\n', '     * Allow another address to spend tokens on your behalf while mitigating a double spend.\n', '     *\n', '     * Subsequent calls to this function overwrite the previous balance.\n', '     * The old value must match the current allowance otherwise this call reverts.\n', '     *\n', '     * @param spender   The address authorized to spend your tokens.\n', '     * @param value     The maximum amount of tokens they can spend.\n', '     * @param oldValue  The current allowance for this spender.\n', '     */\n', '    function safeApprove(address spender, uint256 value, uint256 oldValue) public returns (bool) {\n', '        require(isAuthorised(spender), "Target of safe approve has not passed KYC");\n', '        require(spender != address(0x0), "Cannot approve null address.");\n', '        require(oldValue == allowanceCollection[msg.sender][spender], "The expected old value did not match current allowance.");\n', '\n', '        allowanceCollection[msg.sender][spender] = value;\n', '        emit Approval(msg.sender, spender, value);\n', '\n', '        return true;\n', '    }\n', '\n', '    /**\n', '     * The hash for all Know Your Customer information is calculated outside but stored here.\n', '     * This storage will be cleared once the ICO completes, see closeIco().\n', '     *\n', '     * ---- ICO-Platform Note ----\n', "     * The horizon-globex.com ICO platform's KYC app will register a hash of the Contributors\n", '     * KYC submission on the blockchain. Our Swiss financial-intermediary KYC provider will be \n', '     * notified of the submission and retrieve the Contributor data for formal review.\n', '     *\n', '     * All Contributors must successfully complete our ICO KYC review prior to being allowed on-board.\n', '     * -- End ICO-Platform Note --\n', '     *\n', '     * @param sha   The hash of the customer data.\n', '    */\n', '    function setKycHash(bytes32 sha) public onlyOwner {\n', '        require(!isIcoComplete, "The ICO phase has ended, you can no longer set KYC hashes.");\n', '\n', '        // This is deliberately vague to reduce the links to user data.  To verify users you\n', '        // must go through the KYC Provider firm off-chain.\n', '        kycHashes.push(sha);\n', '    }\n', '\n', '    /**\n', '     * A user has passed KYC verification, store them on the blockchain in the order it happened.\n', '     * This will be cleared once the ICO completes, see closeIco().\n', '     *\n', '     * ---- ICO-Platform Note ----\n', "     * The horizon-globex.com ICO platform's registered KYC provider submits their approval\n", '     * for this Contributor to particpate using the ICO-Platform portal. \n', '     *\n', '     * Each Contributor will then be sent the Ethereum, Bitcoin and IBAN account numbers to\n', '     * deposit their Approved Contribution in exchange for VOX Tokens.\n', '     * -- End ICO-Platform Note --\n', '     *\n', "     * @param who   The user's address.\n", '     */\n', '    function kycApproved(address who) public onlyKycProvider {\n', '        require(!isIcoComplete, "The ICO phase has ended, you can no longer approve.");\n', '        require(who != address(0x0), "Cannot approve a null address.");\n', '\n', '        // NOTE: setAuthorised is onlyOwner, directly perform the actions as KYC Provider.\n', '        authorised[who] = true;\n', '        emit AuthorisationChanged(who, true);\n', '    }\n', '\n', '    /**\n', '     * Set the address that has the authority to approve users by KYC.\n', '     *\n', '     * ---- ICO-Platform Note ----\n', '     * The horizon-globex.com ICO platform shall register a fully licensed Swiss KYC\n', '     * provider to assess each potential Contributor for KYC and AML under Swiss law. \n', '     *\n', '     * -- End ICO-Platform Note --\n', '     *\n', '     * @param who   The address of the KYC provider.\n', '     */\n', '    function setKycProvider(address who) public onlyOwner {\n', '        regulatorApprovedKycProvider = who;\n', '    }\n', '\n', '    /**\n', '     * Retrieve the KYC hash from the specified index.\n', '     *\n', '     * @param   index   The index into the array.\n', '     */\n', '    function getKycHash(uint256 index) public view returns (bytes32) {\n', '        return kycHashes[index];\n', '    }\n', '\n', '    /**\n', '     * When someone referred (the referee) purchases tokens the referrer gets a 1% bonus from the central pool.\n', '     *\n', '     * ---- ICO-Platform Note ----\n', "     * The horizon-globex.com ICO platform's portal shall award referrers as part of the ICO\n", '     * VOX Token issuance procedure as overseen by the Swiss KYC provider. \n', '     *\n', '     * -- End ICO-Platform Note --\n', '     *\n', '     * @param referee   The referred account who just purchased some tokens.\n', '     * @param referrer  The account that referred the one purchasing tokens.\n', '     * @param value     The number of tokens purchased by the referee.\n', '    */\n', '    function awardReferralBonus(address referee, address referrer, uint256 value) private {\n', '        uint256 bonus = value / 100;\n', '        balances[owner] = balances[owner].sub(bonus);\n', '        balances[referrer] = balances[referrer].add(bonus);\n', '        rewardPool_ -= bonus;\n', '        emit ReferralRedeemed(referee, referrer, bonus);\n', '    }\n', '\n', '    /**\n', '     * During the ICO phase the owner will allocate tokens once KYC completes and funds are deposited.\n', '     *\n', '     * ---- ICO-Platform Note ----\n', "     * The horizon-globex.com ICO platform's portal shall issue VOX Token to Contributors on receipt of \n", '     * the Approved Contribution funds at the KYC providers Escrow account/wallets.\n', '     * Only after VOX Tokens are issued to the Contributor can the Swiss KYC provider allow the transfer\n', '     * of funds from their Escrow to Company.\n', '     *\n', '     * -- End ICO-Platform Note --\n', '     *\n', '     * @param to       The recipient of the tokens.\n', '     * @param value    The number of tokens to send.\n', '     */\n', '    function icoTransfer(address to, uint256 value) public onlyOwner {\n', '        require(!isIcoComplete, "ICO is complete, use transfer().");\n', '\n', '        // If an attempt is made to transfer more tokens than owned, transfer the remainder.\n', '        uint256 toTransfer = (value > (balances[msg.sender] - rewardPool_ )) ? (balances[msg.sender] - rewardPool_) : value;\n', '        \n', '        _transfer(msg.sender, to, toTransfer);\n', '\n', '        // Handle a referred account receiving tokens.\n', '        address referrer = referredBy[to];\n', '        if(referrer != address(0x0)) {\n', '            referredBy[to] = address(0x0);\n', '            awardReferralBonus(to, referrer, toTransfer);\n', '        }\n', '    }\n', '\n', '    /**\n', '     * End the ICO phase in accordance with KYC procedures and clean up.\n', '     *\n', '     * ---- ICO-Platform Note ----\n', "     * The horizon-globex.com ICO platform's portal shall halt the ICO at the end of the \n", '     * Contribution Period, as defined in the ICO Terms and Conditions https://talketh.io/Terms.\n', '     *\n', '     * -- End ICO-Platform Note --\n', '     */\n', '    function closeIco() public onlyOwner {\n', '        require(!isIcoComplete, "The ICO phase has already ended, you cannot close it again.");\n', '        require((balances[owner] - rewardPool_) == 0, "Cannot close ICO when a balance remains in the owner account.");\n', '\n', '        isIcoComplete = true;\n', '\n', '        emit IcoComplete();\n', '    }\n', '\t\n', '    /**\n', '     * Internal transfer, can only be called by this contract\n', '     *\n', '     * @param from     The sender of the tokens.\n', '     * @param to       The recipient of the tokens.\n', '     * @param value    The number of tokens to send.\n', '     */\n', '    function _transfer(address from, address to, uint256 value) internal returns (bool) {\n', '        require(isAuthorised(to), "Target of transfer has not passed KYC");\n', '        require(from != address(0x0), "Cannot send tokens from null address");\n', '        require(to != address(0x0), "Cannot transfer tokens to null");\n', '        require(balances[from] >= value, "Insufficient funds");\n', '\n', '        // Quick exit for zero, but allow it in case this transfer is part of a chain.\n', '        if(value == 0)\n', '            return true;\n', '\t\t\n', '        // Perform the transfer.\n', '        balances[from] = balances[from].sub(value);\n', '        balances[to] = balances[to].add(value);\n', '\t\t\n', '        // Any tokens sent to to owner are implicitly burned.\n', '        if (to == owner) {\n', '            _burn(to, value);\n', '        }\n', '\n', '        return true;\n', '    }\n', '\n', '    /**\n', '     * Permanently destroy tokens belonging to a user.\n', '     *\n', '     * @param addressToBurn    The owner of the tokens to burn.\n', '     * @param value            The number of tokens to burn.\n', '     */\n', '    function _burn(address addressToBurn, uint256 value) private returns (bool success) {\n', '        require(value > 0, "Tokens to burn must be greater than zero");\n', '        require(balances[addressToBurn] >= value, "Tokens to burn exceeds balance");\n', '\n', '        balances[addressToBurn] = balances[addressToBurn].sub(value);\n', '        totalSupply_ = totalSupply_.sub(value);\n', '\n', '        emit Burn(msg.sender, value);\n', '\n', '        return true;\n', '    }\n', '}']