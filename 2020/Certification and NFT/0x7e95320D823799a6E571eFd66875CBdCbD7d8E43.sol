['// SPDX-License-Identifier: MIT\n', 'pragma solidity 0.7.0;\n', '\n', '/**\n', ' * @title IERC1404 - Simple Restricted Token Standard \n', ' * @dev https://github.com/ethereum/eips/issues/1404\n', ' */\n', 'interface IERC1404 {\n', '    // Implementation of all the restriction of transfer and returns error code\n', '    function detectTransferRestriction (address from, address to, uint256 value) external view returns (uint8);\n', '    // Returns error message off error code\n', '    function messageForTransferRestriction (uint8 restrictionCode) external view returns (string memory);\n', '}\n', '    \n', '    \n', '/**\n', ' * @title IERC1404Checks \n', ' * @dev Interface for all the checks for Restricted Transfer Contract \n', ' */\n', 'interface IERC1404Checks {\n', '    // Check if the transfer is paused or not.\n', '    function paused () external view returns (bool);\n', '    // Check if sender and receiver waller is whitelisted\n', '    function checkWhitelists (address from, address to) external view returns (bool);\n', '    // Check if the sender wallet is locked\n', '    function isLocked(address wallet) external view returns (bool);\n', '}\n', '\n', '\n', '\n', '/**\n', ' * @title Ownable\n', ' * @dev The Ownable contract has an owner address, and provides basic authorization control\n', ' * functions, this simplifies the implementation of "user permissions".\n', ' */\n', 'contract Ownable {\n', '    \n', '    address public owner;\n', '    address private _newOwner;\n', '    \n', '    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);\n', '    \n', '    constructor () {\n', '        owner = msg.sender;\n', '        emit OwnershipTransferred(address(0), owner);\n', '    }\n', '\n', '    // Throws if called by any account other than the owner\n', '    modifier onlyOwner() {\n', '        require(isOwner(), "Ownable: caller is not the owner");\n', '        _;\n', '    }\n', '\n', '    // True if `msg.sender` is the owner of the contract.\n', '    function isOwner() public view returns (bool) {\n', '        return msg.sender == owner;\n', '    }\n', '\n', '    // Allows the current owner to relinquish control of the contract.\n', '    function renounceOwnership() public onlyOwner {\n', '        emit OwnershipTransferred(owner, address(0));\n', '        owner = address(0);\n', '    }\n', '\n', '    // Propose the new Owner of the smart contract \n', '    function proposeOwnership(address newOwner) public onlyOwner {\n', '        require(newOwner != address(0), "Ownable: new owner is the zero address");\n', '        _newOwner = newOwner;\n', '    }\n', '    \n', '    // Accept the ownership of the smart contract as a new Owner\n', '    function acceptOwnership() public {\n', '        require(msg.sender == _newOwner, "Ownable: caller is not the new owner");\n', '        emit OwnershipTransferred(owner, _newOwner);\n', '        owner = _newOwner;\n', '    }\n', '}\n', '\n', '\n', '/**\n', ' * @title RestrictedMessages\n', ' * @dev All the messages and code of transfer restriction\n', ' */ \n', 'contract RestrictedMessages {\n', '    \n', '    uint8 internal constant SUCCESS = 0;\n', '    uint8 internal constant PAUSED_FAILURE = 1;\n', '    uint8 internal constant WHITELIST_FAILURE = 2;\n', '    uint8 internal constant TIMELOCK_FAILURE = 3;\n', '    \n', '    string internal constant SUCCESS_MSG = "SUCCESS";\n', '    string internal constant PAUSED_FAILURE_MSG = "ERROR: All transfer is paused now";\n', '    string internal constant WHITELIST_FAILURE_MSG = "ERROR: Wallet is not whitelisted";\n', '    string internal constant TIMELOCK_FAILURE_MSG = "ERROR: Wallet is locked";\n', '    string internal constant UNKNOWN = "ERROR: Unknown";\n', '}\n', '\n', '\n', '/**\n', ' * @title ERC1404\n', ' * @dev Simple Restricted Token Standard  \n', ' */ \n', 'contract ERC1404 is IERC1404, RestrictedMessages, Ownable {\n', '    \n', '    // Checkers contract address, basically RVW token contract address\n', '    IERC1404Checks public checker;\n', '\n', '    event UpdatedChecker(IERC1404Checks indexed _checker);\n', '    \n', '    // Update the token contract address\n', '    function updateChecker(IERC1404Checks _checker) public onlyOwner{\n', '        require(_checker != IERC1404Checks(0), "ERC1404: Address should not be zero.");\n', '        checker = _checker;\n', '        emit UpdatedChecker(_checker);\n', '    }\n', '    \n', '    // All checks of transfer function\n', '    // If contract paused, sender wallet locked and wallet not whitelisted then return error code else success\n', '    // Note, Now there is no use of amount for restriction, but might be in the future\n', '    function detectTransferRestriction (address from, address to, uint256 amount) public override view returns (uint8) {\n', '        if(checker.paused()){ \n', '            return PAUSED_FAILURE; \n', '        }\n', '        if(!checker.checkWhitelists(from, to)){ \n', '            return WHITELIST_FAILURE;\n', '        }\n', '        if(checker.isLocked(from)){ \n', '            return TIMELOCK_FAILURE;\n', '        }\n', '        return SUCCESS;\n', '    }\n', '    \n', '    // Return the error message of error code\n', '    function messageForTransferRestriction (uint8 code) public override pure returns (string memory){\n', '        if (code == SUCCESS) {\n', '            return SUCCESS_MSG;\n', '        }\n', '        if (code == PAUSED_FAILURE) {\n', '            return PAUSED_FAILURE_MSG;\n', '        }\n', '        if (code == WHITELIST_FAILURE) {\n', '            return WHITELIST_FAILURE_MSG;\n', '        }\n', '        if (code == TIMELOCK_FAILURE) {\n', '            return TIMELOCK_FAILURE_MSG;\n', '        }\n', '        return UNKNOWN;\n', '    }\n', '\n', '}']