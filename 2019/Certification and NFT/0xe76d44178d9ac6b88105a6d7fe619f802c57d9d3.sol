['/**\n', ' *Submitted for verification at Etherscan.io on 2019-07-10\n', '*/\n', '\n', 'pragma solidity ^0.4.24;\n', '\n', 'contract Ownable {\n', '    address public owner;\n', '\n', '    event OwnerTransferred(\n', '        address indexed oldOwner,\n', '        address indexed newOwner\n', '    );\n', '\n', '    constructor() public {\n', '        owner = msg.sender;\n', '    }\n', '\n', '    modifier onlyOwner() {\n', '        require(msg.sender == owner, "Owner account is required");\n', '        _;\n', '    }\n', '\n', '    function transferOwner(address newOwner)\n', '    public\n', '    onlyOwner {\n', '        require(newOwner != owner, "New Owner cannot be the current owner");\n', '        require(newOwner != address(0), "New Owner cannot be zero address");\n', '        address prevOwner = owner;\n', '        owner = newOwner;\n', '        emit OwnerTransferred(prevOwner, newOwner);\n', '    }\n', '}\n', '\n', 'library AdditiveMath {\n', '    function add(uint256 x, uint256 y)\n', '    internal\n', '    pure\n', '    returns (uint256) {\n', '        uint256 sum = x + y;\n', '        require(sum >= x, "Results in overflow");\n', '        return sum;\n', '    }\n', '\n', '    function subtract(uint256 x, uint256 y)\n', '    internal\n', '    pure\n', '    returns (uint256) {\n', '        require(y <= x, "Results in underflow");\n', '        return x - y;\n', '    }\n', '}\n', '\n', 'library AddressMap {\n', '    struct Data {\n', '        int256 count;\n', '        mapping(address => int256) indices;\n', '        mapping(int256 => address) items;\n', '    }\n', '\n', '    address constant ZERO_ADDRESS = address(0);\n', '\n', '    function append(Data storage self, address addr)\n', '    internal\n', '    returns (bool) {\n', '        if (addr == ZERO_ADDRESS) {\n', '            return false;\n', '        }\n', '\n', '        int256 index = self.indices[addr] - 1;\n', '        if (index >= 0 && index < self.count) {\n', '            return false;\n', '        }\n', '\n', '        self.count++;\n', '        self.indices[addr] = self.count;\n', '        self.items[self.count] = addr;\n', '        return true;\n', '    }\n', '\n', '    function remove(Data storage self, address addr)\n', '    internal\n', '    returns (bool) {\n', '        int256 oneBasedIndex = self.indices[addr];\n', '        if (oneBasedIndex < 1 || oneBasedIndex > self.count) {\n', '            return false;  // address doesn&#39;t exist, or zero.\n', '        }\n', '\n', '        // When the item being removed is not the last item in the collection,\n', '        // replace that item with the last one, otherwise zero it out.\n', '        //\n', '        //  If {2} is the item to be removed\n', '        //     [0, 1, 2, 3, 4]\n', '        //  The result would be:\n', '        //     [0, 1, 4, 3]\n', '        //\n', '        if (oneBasedIndex < self.count) {\n', '            // Replace with last item\n', '            address last = self.items[self.count];  // Get the last item\n', '            self.indices[last] = oneBasedIndex;     // Update last items index to current index\n', '            self.items[oneBasedIndex] = last;       // Update current index to last item\n', '            delete self.items[self.count];          // Delete the last item, since it&#39;s moved\n', '        } else {\n', '            // Delete the address\n', '            delete self.items[oneBasedIndex];\n', '        }\n', '\n', '        delete self.indices[addr];\n', '        self.count--;\n', '        return true;\n', '    }\n', '\n', '    function clear(Data storage self)\n', '    internal {\n', '        self.count = 0;\n', '    }\n', '\n', '    function at(Data storage self, int256 index)\n', '    internal\n', '    view\n', '    returns (address) {\n', '        require(index >= 0 && index < self.count, "Index outside of bounds.");\n', '        return self.items[index + 1];\n', '    }\n', '\n', '    function indexOf(Data storage self, address addr)\n', '    internal\n', '    view\n', '    returns (int256) {\n', '        if (addr == ZERO_ADDRESS) {\n', '            return -1;\n', '        }\n', '\n', '        int256 index = self.indices[addr] - 1;\n', '        if (index < 0 || index >= self.count) {\n', '            return -1;\n', '        }\n', '        return index;\n', '    }\n', '\n', '    function exists(Data storage self, address addr)\n', '    internal\n', '    view\n', '    returns (bool) {\n', '        int256 index = self.indices[addr] - 1;\n', '        return index >= 0 && index < self.count;\n', '    }\n', '\n', '}\n', '\n', 'interface ERC20 {\n', '    event Approval(address indexed owner, address indexed spender, uint256 value);\n', '    event Transfer(address indexed from, address indexed to, uint256 value);\n', '\n', '    function allowance(address owner, address spender) external view returns (uint256);\n', '    function approve(address spender, uint256 value) external returns (bool);\n', '    function balanceOf(address who) external view returns (uint256);\n', '    function totalSupply() external view returns (uint256);\n', '    function transfer(address to, uint256 value) external returns (bool);\n', '    function transferFrom(address from, address to, uint256 value) external returns (bool);\n', '}\n', '\n', 'contract ERC1404 is ERC20 {\n', '    function detectTransferRestriction (address from, address to, uint256 value) public view returns (uint8);\n', '    function messageForTransferRestriction (uint8 restrictionCode) public view returns (string);\n', '}\n', '\n', 'contract NT1404 is ERC1404, Ownable {\n', '\n', '    // ------------------------------- Variables -------------------------------\n', '\n', '    using AdditiveMath for uint256;\n', '    using AddressMap for AddressMap.Data;\n', '\n', '    address constant internal ZERO_ADDRESS = address(0);\n', '    string public constant name = "NEWTOUCH BCL LAB TEST";\n', '    string public constant symbol = "NTBCLTEST";\n', '    uint8 public constant decimals = 0;\n', '\n', '    AddressMap.Data public shareholders;\n', '    bool public issuingFinished = false;\n', '\n', '    mapping(address => uint256) internal balances;\n', '    uint256 internal totalSupplyTokens;\n', '    \n', '    uint8 public constant SUCCESS_CODE = 0;\n', '    string public constant SUCCESS_MESSAGE = "SUCCESS";\n', '\n', '    // ------------------------------- Modifiers -------------------------------\n', '\n', '    modifier canIssue() {\n', '        require(!issuingFinished, "Issuing is already finished");\n', '        _;\n', '    }\n', '\n', '    modifier hasFunds(address addr, uint256 tokens) {\n', '        require(tokens <= balances[addr], "Insufficient funds");\n', '        _;\n', '    }\n', '    \n', '    modifier notRestricted (address from, address to, uint256 value) {\n', '        uint8 restrictionCode = detectTransferRestriction(from, to, value);\n', '        require(restrictionCode == SUCCESS_CODE, messageForTransferRestriction(restrictionCode));\n', '        _;\n', '    }\n', '\n', '    // -------------------------------- Events ---------------------------------\n', '\n', '    event Issue(address indexed to, uint256 tokens);\n', '    event IssueFinished();\n', '    event ShareholderAdded(address shareholder);\n', '    event ShareholderRemoved(address shareholder);\n', '\n', '    // -------------------------------------------------------------------------\n', '\n', '    function detectTransferRestriction (address from, address to, uint256 value)\n', '        public\n', '        view\n', '        returns (uint8 restrictionCode)\n', '    {\n', '        restrictionCode = SUCCESS_CODE;\n', '    }\n', '        \n', '    function messageForTransferRestriction (uint8 restrictionCode)\n', '        public\n', '        view\n', '        returns (string message)\n', '    {\n', '        if (restrictionCode == SUCCESS_CODE) {\n', '            message = SUCCESS_MESSAGE;\n', '        }\n', '    }\n', '    \n', '    function transfer (address to, uint256 value)\n', '        public\n', '        hasFunds(msg.sender, value)\n', '        notRestricted(msg.sender, to, value)\n', '        returns (bool success)\n', '    {\n', '        transferTokens(msg.sender, to, value);\n', '        success = true;\n', '    }\n', '\n', '    /**\n', '     * (not used)\n', '     */\n', '    function transferFrom (address from, address to, uint256 value)\n', '        public\n', '        returns (bool success)\n', '    {\n', '        success = false;\n', '    }\n', '\n', '    function issueTokens(uint256 quantity)\n', '    external\n', '    onlyOwner\n', '    canIssue\n', '    returns (bool) {\n', '        // Avoid doing any state changes for zero quantities\n', '        if (quantity > 0) {\n', '            totalSupplyTokens = totalSupplyTokens.add(quantity);\n', '            balances[owner] = balances[owner].add(quantity);\n', '            shareholders.append(owner);\n', '        }\n', '        emit Issue(owner, quantity);\n', '        emit Transfer(ZERO_ADDRESS, owner, quantity);\n', '        return true;\n', '    }\n', '\n', '    function finishIssuing()\n', '    external\n', '    onlyOwner\n', '    canIssue\n', '    returns (bool) {\n', '        issuingFinished = true;\n', '        emit IssueFinished();\n', '        return issuingFinished;\n', '    }\n', '\n', '    /**\n', '     * (not used)\n', '     */\n', '    function approve(address spender, uint256 tokens)\n', '    external\n', '    returns (bool) {\n', '        return false;\n', '    }\n', '\n', '    // -------------------------------- Getters --------------------------------\n', '\n', '    function totalSupply()\n', '    external\n', '    view\n', '    returns (uint256) {\n', '        return totalSupplyTokens;\n', '    }\n', '\n', '    function balanceOf(address addr)\n', '    external\n', '    view\n', '    returns (uint256) {\n', '        return balances[addr];\n', '    }\n', '\n', '    /**\n', '     *  (not used)\n', '     */\n', '    function allowance(address addrOwner, address spender)\n', '    external\n', '    view\n', '    returns (uint256) {\n', '        return 0;\n', '    }\n', '\n', '    function holderAt(int256 index)\n', '    external\n', '    view\n', '    returns (address){\n', '        return shareholders.at(index);\n', '    }\n', '\n', '    function isHolder(address addr)\n', '    external\n', '    view\n', '    returns (bool) {\n', '        return shareholders.exists(addr);\n', '    }\n', '\n', '\n', '    // -------------------------------- Private --------------------------------\n', '\n', '    function transferTokens(address from, address to, uint256 tokens)\n', '    private {\n', '        // Update balances\n', '        balances[from] = balances[from].subtract(tokens);\n', '        balances[to] = balances[to].add(tokens);\n', '        emit Transfer(from, to, tokens);\n', '\n', '        // Adds the shareholder if they don&#39;t already exist.\n', '        if (balances[to] > 0 && shareholders.append(to)) {\n', '            emit ShareholderAdded(to);\n', '        }\n', '        // Remove the shareholder if they no longer hold tokens.\n', '        if (balances[from] == 0 && shareholders.remove(from)) {\n', '            emit ShareholderRemoved(from);\n', '        }\n', '    }\n', '\n', '}']