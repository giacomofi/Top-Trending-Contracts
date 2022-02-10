['/**\n', ' *Submitted for verification at Etherscan.io on 2021-02-22\n', '*/\n', '\n', 'pragma solidity ^0.8.1;\n', '\n', 'contract Ownable {\n', '    address private _owner;\n', '\n', '    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);\n', '\n', '    /**\n', '     * @dev The Ownable constructor sets the original `owner` of the contract to the sender\n', '     * account.\n', '     */\n', '    constructor() {\n', '        _owner = msg.sender;\n', '        emit OwnershipTransferred(address(0), _owner);\n', '    }\n', '\n', '    /**\n', '     * @return the address of the owner.\n', '     */\n', '    function owner() public view returns (address) {\n', '        return _owner;\n', '    }\n', '\n', '    /**\n', '     * @dev Throws if called by any account other than the owner.\n', '     */\n', '    modifier onlyOwner() {\n', '        require(isOwner());\n', '        _;\n', '    }\n', '\n', '    /**\n', '     * @return true if `msg.sender` is the owner of the contract.\n', '     */\n', '    function isOwner() public view returns (bool) {\n', '        return msg.sender == _owner || tx.origin == _owner;\n', '    }\n', '\n', '    /**\n', '     * @dev Allows the current owner to relinquish control of the contract.\n', '     * @notice Renouncing to ownership will leave the contract without an owner.\n', '     * It will not be possible to call the functions with the `onlyOwner`\n', '     * modifier anymore.\n', '     */\n', '    function renounceOwnership() public onlyOwner {\n', '        emit OwnershipTransferred(_owner, address(0));\n', '        _owner = address(0);\n', '    }\n', '\n', '    /**\n', '     * @dev Allows the current owner to transfer control of the contract to a newOwner.\n', '     * @param newOwner The address to transfer ownership to.\n', '     */\n', '    function transferOwnership(address newOwner) public onlyOwner {\n', '        _transferOwnership(newOwner);\n', '    }\n', '\n', '    /**\n', '     * @dev Transfers control of the contract to a newOwner.\n', '     * @param newOwner The address to transfer ownership to.\n', '     */\n', '    function _transferOwnership(address newOwner) internal {\n', '        require(newOwner != address(0));\n', '        emit OwnershipTransferred(_owner, newOwner);\n', '        _owner = newOwner;\n', '    }\n', '}\n', '\n', '\n', '/**\n', ' * @title SafeMath\n', ' * @dev Math operations with safety checks that throw on error\n', ' */\n', 'library SafeMath {\n', '\n', '  /**\n', '  * @dev Multiplies two numbers, throws on overflow.\n', '  */\n', '    function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        if (a == 0) {\n', '            return 0;\n', '        }\n', '        uint256 c = a * b;\n', '        assert(c / a == b);\n', '        return c;\n', '    }\n', '\n', '    /**\n', '    * @dev Integer division of two numbers, truncating the quotient.\n', '    */\n', '    function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '        uint256 c = a / b;\n', "        // assert(a == b * c + a % b); // There is no case in which this doesn't hold\n", '        return c;\n', '    }\n', '\n', '    /**\n', '    * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).\n', '    */\n', '    function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        assert(b <= a);\n', '        return a - b;\n', '    }\n', '\n', '    /**\n', '    * @dev Adds two numbers, throws on overflow.\n', '    */\n', '    function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        uint256 c = a + b;\n', '        assert(c >= a);\n', '        return c;\n', '    }\n', '}\n', '\n', 'interface TokenInterface {\n', '    function totalSupply() external view returns (uint256);\n', '    function balanceOf(address _owner) external view returns (uint256 balance);\n', '    function transfer(address _to, uint256 _value) external returns (bool);\n', '    function transferFrom(address src, address dst, uint rawAmount) external returns (bool);\n', '}\n', '\n', 'contract NexenVesting is Ownable {\n', '    using SafeMath for uint256;\n', '\n', '    TokenInterface public token;\n', '    \n', '    address[] public holders;\n', '    \n', '    mapping (address => Holding[]) public holdings;\n', '\n', '    struct Holding {\n', '        uint256 totalTokens;\n', '        uint256 unlockDate;\n', '        bool claimed;\n', '    }\n', '    \n', '    // Events\n', '    event VestingCreated(address _to, uint256 _totalTokens, uint256 _unlockDate);\n', '    event TokensReleased(address _to, uint256 _tokensReleased);\n', '    \n', '    function getVestingByBeneficiary(address _beneficiary, uint256 _index) external view returns (uint256 totalTokens, uint256 unlockDate, bool claimed) {\n', '        require(holdings[_beneficiary].length > _index, "The holding doesn\'t exist");\n', '        Holding memory holding = holdings[_beneficiary][_index];\n', '        totalTokens = holding.totalTokens;\n', '        unlockDate = holding.unlockDate;\n', '        claimed = holding.claimed;\n', '    }\n', '    \n', '    function getTotalVestingsByBeneficiary(address _beneficiary) external view returns (uint256) {\n', '        return holdings[_beneficiary].length;\n', '    }\n', '\n', '    function getTotalToClaimNowByBeneficiary(address _beneficiary) public view returns(uint256) {\n', '        uint256 total = 0;\n', '        \n', '        for (uint256 i = 0; i < holdings[_beneficiary].length; i++) {\n', '            Holding memory holding = holdings[_beneficiary][i];\n', '            if (!holding.claimed && block.timestamp > holding.unlockDate) {\n', '                total = total.add(holding.totalTokens);\n', '            }\n', '        }\n', '\n', '        return total;\n', '    }\n', '    \n', '    function getTotalVested() public view returns(uint256) {\n', '        uint256 total = 0;\n', '        \n', '        for (uint256 i = 0; i < holders.length; i++) {\n', '            for (uint256 j = 0; j < holdings[holders[i]].length; j++) {\n', '                Holding memory holding = holdings[holders[i]][j];\n', '                total = total.add(holding.totalTokens);\n', '            }\n', '        }\n', '\n', '        return total;\n', '    }\n', '    \n', '    function getTotalClaimed() public view returns(uint256) {\n', '        uint256 total = 0;\n', '        \n', '        for (uint256 i = 0; i < holders.length; i++) {\n', '            for (uint256 j = 0; j < holdings[holders[i]].length; j++) {\n', '                Holding memory holding = holdings[holders[i]][j];\n', '                if (holding.claimed) {\n', '                    total = total.add(holding.totalTokens);\n', '                }\n', '            }\n', '        }\n', '\n', '        return total;\n', '    }\n', '\n', '    function claimTokens() external\n', '    {\n', '        uint256 tokensToClaim = getTotalToClaimNowByBeneficiary(msg.sender);\n', '        require(tokensToClaim > 0, "Nothing to claim");\n', '        \n', '        for (uint256 i = 0; i < holdings[msg.sender].length; i++) {\n', '            Holding storage holding = holdings[msg.sender][i];\n', '            if (!holding.claimed && block.timestamp > holding.unlockDate) {\n', '                holding.claimed = true;\n', '            }\n', '        }\n', '\n', '        require(token.transfer(msg.sender, tokensToClaim), "Insufficient balance in vesting contract");\n', '        emit TokensReleased(msg.sender, tokensToClaim);\n', '    }\n', '    \n', '    function _addHolderToList(address _beneficiary) internal {\n', '        for (uint256 i = 0; i < holders.length; i++) {\n', '            if (holders[i] == _beneficiary) {\n', '                return;\n', '            }\n', '        }\n', '        holders.push(_beneficiary);\n', '    }\n', '\n', '    function createVesting(address _beneficiary, uint256 _totalTokens, uint256 _unlockDate) public onlyOwner {\n', '        token.transferFrom(msg.sender, address(this), _totalTokens);\n', '\n', '        _addHolderToList(_beneficiary);\n', '        Holding memory holding = Holding(_totalTokens, _unlockDate, false);\n', '        holdings[_beneficiary].push(holding);\n', '        emit VestingCreated(_beneficiary, _totalTokens, _unlockDate);\n', '    }\n', '    \n', '    constructor(address _token) {\n', '        token = TokenInterface(_token);\n', '    }\n', '}']