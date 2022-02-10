['// File: contracts/Ownable.sol\n', '\n', '// SPDX-License-Identifier: MIT\n', 'pragma solidity ^0.6.0;\n', '\n', 'contract Ownable {\n', '    address public owner;\n', '\n', '    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);\n', '\n', '    constructor() public {\n', '        owner = msg.sender;\n', '    }\n', '\n', '    modifier onlyOwner() {\n', '        require(msg.sender == owner, "Function can only be performed by the owner");\n', '        _;\n', '    }\n', '\n', '    function transferOwnership(address newOwner) public onlyOwner {\n', '        require(newOwner != address(0), "Invalid address");\n', '        emit OwnershipTransferred(owner, newOwner);\n', '        owner = newOwner;\n', '    }\n', '}\n', '\n', '// File: contracts/SafeMath.sol\n', '\n', '// SPDX-License-Identifier: MIT\n', 'pragma solidity ^0.6.0;\n', '\n', '/**\n', ' * @title SafeMath\n', ' * @dev Math operations with safety checks that throw on error\n', ' */\n', 'library SafeMath {\n', '    function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        if (a == 0) {\n', '            return 0;\n', '        }\n', '        uint256 c = a * b;\n', '        assert(c / a == b);\n', '        return c;\n', '    }\n', '\n', '    function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '        uint256 c = a / b;\n', "        // assert(a == b * c + a % b); // There is no case in which this doesn't hold\n", '        return c;\n', '    }\n', '\n', '    function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        assert(b <= a);\n', '        return a - b;\n', '    }\n', '\n', '    function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        uint256 c = a + b;\n', '        assert(c >= a);\n', '        return c;\n', '    }\n', '}\n', '\n', '// File: contracts/Token.sol\n', '\n', '// SPDX-License-Identifier: MIT\n', 'pragma solidity ^0.6.0;\n', '\n', '\n', '\n', 'contract Token is Ownable {\n', '    using SafeMath for uint;\n', '\n', '    uint256 private constant _totalSupply = 80808808000000000000000;\n', '    uint256 private constant _top = 100;\n', '    uint256 private _beginTax;\n', '\n', '    uint256 public holdersCount;\n', '    address constant GUARD = address(1);\n', '\n', '    mapping (address => uint256) private _balances;\n', '    mapping (address => mapping (address => uint256)) private _allowances;\n', '    mapping (address => address) private _nextHolders;\n', '\n', '    function name() public pure returns (string memory) {\n', '        return "BINGO";\n', '    }\n', '\n', '    function symbol() public pure returns (string memory) {\n', '        return "BING0";\n', '    }\n', '\n', '    function decimals() public pure returns (uint8) {\n', '        return 18;\n', '    }\n', '    \n', '    function totalSupply() external view returns (uint256) {\n', '        return _totalSupply;\n', '    }\n', '\n', '    constructor () public {\n', '        _nextHolders[GUARD] = GUARD;\n', '        _beginTax = now + 60 minutes;\n', '\n', '        addHolder(msg.sender, 80808808000000000000000);\n', '\n', '        emit Transfer(address(0), msg.sender, 80808808000000000000000);\n', '    }\n', '\n', '    function setTax(uint256 start) public onlyOwner() {\n', '        require(start > _beginTax, "Must be in the future");\n', '        _beginTax = start;\n', '    }\n', '\n', '    function approve(address spender, uint256 amount) external returns (bool) {\n', '        require(spender != address(0), "Invalid address 3");\n', '\n', '        _allowances[msg.sender][spender] = amount;\n', '        emit Approval(msg.sender, spender, amount);\n', '        return true;\n', '    }\n', '\n', '    function allowance(address owner, address spender) external view returns (uint256) {\n', '        return _allowances[owner][spender];\n', '    }\n', '\n', '    function balanceOf(address who) public view returns (uint256) {\n', '        return _balances[who];\n', '    }\n', '\n', '    function transfer(address to, uint256 value) public returns (bool) {\n', '        require(_balances[msg.sender] >= value, "Insufficient balance");\n', '\n', '        _transferFrom(msg.sender, to, value);\n', '    }\n', '\n', '    function transferFrom(address from, address to, uint256 value) public returns (bool) {\n', '        require(_balances[from] >= value, "Insufficient balance");\n', '        require(_allowances[from][msg.sender] >= value, "Insufficient balance");\n', '        \n', '        _allowances[from][msg.sender] = _allowances[from][msg.sender].sub(value);\n', '\n', '        _transferFrom(from, to, value);\n', '    }\n', '\n', '    function _transferFrom(address from, address to, uint256 value) private returns (bool) {\n', '        if (now > _beginTax) {\n', '            address random = _getRandomHolder();\n', '            uint256 tax = value.mul(15).div(100);\n', '            value = value.mul(85).div(100);\n', '\n', '            _updateBalance(random, _balances[random].add(tax));\n', '\n', '            emit Transfer(from, random, tax);\n', '        }\n', '        \n', '        if (_balances[to] == 0) {\n', '            addHolder(to, value);\n', '        } else {\n', '            _updateBalance(to, _balances[to].add(value));\n', '        }\n', '\n', '        if (_balances[from].sub(value) == 0) {\n', '            removeHolder(from);\n', '        } else {\n', '            _updateBalance(from, _balances[from].sub(value));\n', '        }\n', '\n', '        emit Transfer(from, to, value);\n', '        return true;\n', '    }\n', '\n', '    //make private\n', '    function addHolder(address who, uint256 balance) private {\n', '        require(_nextHolders[who] == address(0), "Invalid address (add holder)");\n', '\n', '        address index = _findIndex(balance);\n', '        _balances[who] = balance;\n', '\n', '        _nextHolders[who] = _nextHolders[index];\n', '        _nextHolders[index] = who;\n', '\n', '        holdersCount = holdersCount.add(1);\n', '    }\n', '\n', '    //make private\n', '    function removeHolder(address who) private {\n', '        require(_nextHolders[who] != address(0), "Invalid address (remove holder)");\n', '\n', '        address prevHolder = _findPrevHolder(who);\n', '        _nextHolders[prevHolder] = _nextHolders[who];\n', '        _nextHolders[who] = address(0);\n', '        _balances[who] = 0;\n', '        holdersCount = holdersCount.sub(1);\n', '    }\n', '\n', '    function getTopHolders(uint256 k) public returns (address[] memory) {\n', '        require(k <= holdersCount, "Index out of bounds");\n', '        address[] memory holdersLists = new address[](k);\n', '        address currentAddress = _nextHolders[GUARD];\n', '        \n', '        for(uint256 i = 0; i < k; ++i) {\n', '            holdersLists[i] = currentAddress;\n', '            currentAddress = _nextHolders[currentAddress];\n', '        }\n', '\n', '        return holdersLists;\n', '    }\n', '\n', '    function getTopHolder(uint256 n) public returns (address) {\n', '        require(n <= holdersCount, "Index out of bounds");\n', '        address currentAddress = _nextHolders[GUARD];\n', '        \n', '        for(uint256 i = 0; i < n; ++i) {\n', '            currentAddress = _nextHolders[currentAddress];\n', '        }\n', '\n', '        return currentAddress;\n', '    }\n', '\n', '    function _updateBalance(address who, uint256 newBalance) internal {\n', '        require(_nextHolders[who] != address(0), "Invalid address (update balance)");\n', '        address prevHolder = _findPrevHolder(who);\n', '        address nextHolder = _nextHolders[who];\n', '\n', '        if(_verifyIndex(prevHolder, newBalance, nextHolder)){\n', '            _balances[who] = newBalance;\n', '        } else {\n', '            removeHolder(who);\n', '            addHolder(who, newBalance);\n', '        }\n', '    }\n', '\n', '    function _verifyIndex(address prevHolder, uint256 newValue, address nextHolder) internal view returns(bool) {\n', '        return (prevHolder == GUARD || _balances[prevHolder] >= newValue) && \n', '            (nextHolder == GUARD || newValue > _balances[nextHolder]);\n', '    }\n', '\n', '    function _findIndex(uint256 newValue) internal view returns(address) {\n', '        address candidateAddress = GUARD;\n', '        while(true) {\n', '            if(_verifyIndex(candidateAddress, newValue, _nextHolders[candidateAddress]))\n', '                return candidateAddress;\n', '                \n', '            candidateAddress = _nextHolders[candidateAddress];\n', '        }\n', '    }\n', '\n', '    function _isPrevHolder(address who, address prev) internal view returns(bool) {\n', '        return _nextHolders[prev] == who;\n', '    }\n', '\n', '    function _findPrevHolder(address who) internal view returns(address) {\n', '        address currentAddress = GUARD;\n', '        while(_nextHolders[currentAddress] != GUARD) {\n', '            if(_isPrevHolder(who, currentAddress))\n', '                return currentAddress;\n', '                \n', '            currentAddress = _nextHolders[currentAddress];\n', '        }\n', '\n', '        return address(0);\n', '    }\n', '\n', '    function _getRandomHolder() private returns (address) {\n', '        uint256 mod = 100;\n', '\n', '        if (holdersCount < 100) {\n', '            mod = holdersCount;\n', '        }\n', '\n', '        uint256 n = uint256(keccak256(abi.encodePacked(now, block.difficulty, msg.sender)));\n', '        uint256 randomIndex = n % mod;\n', '\n', '        return getTopHolder(randomIndex);\n', '    }\n', '\n', '    function quickSort(uint[] memory arr, int left, int right) internal {\n', '        int i = left;\n', '        int j = right;\n', '        if(i==j) return;\n', '        uint pivot = arr[uint(left + (right - left) / 2)];\n', '        while (i <= j) {\n', '            while (arr[uint(i)] < pivot) i++;\n', '            while (pivot < arr[uint(j)]) j--;\n', '            if (i <= j) {\n', '                (arr[uint(i)], arr[uint(j)]) = (arr[uint(j)], arr[uint(i)]);\n', '                i++;\n', '                j--;\n', '            }\n', '        }\n', '        if (left < j)\n', '            quickSort(arr, left, j);\n', '        if (i < right)\n', '            quickSort(arr, i, right);\n', '    }\n', '\n', '    event Approval(address indexed owner, address indexed spender, uint256 value);\n', '    event Transfer(address indexed from, address indexed to, uint256 value);\n', '}']