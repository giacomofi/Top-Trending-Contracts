['/**\n', ' *Submitted for verification at Etherscan.io on 2021-06-03\n', '*/\n', '\n', '/**\n', ' *Submitted for verification at Etherscan.io on 2021-05-21\n', '*/\n', '\n', 'pragma solidity ^0.6.12;\n', '\n', '// SPDX-License-Identifier: MIT\n', '\n', 'library EnumerableSet {\n', '    // To implement this library for multiple types with as little code\n', '    // repetition as possible, we write it in terms of a generic Set type with\n', '    // bytes32 values.\n', '    // The Set implementation uses private functions, and user-facing\n', '    // implementations (such as AddressSet) are just wrappers around the\n', '    // underlying Set.\n', '    // This means that we can only create new EnumerableSets for types that fit\n', '    // in bytes32.\n', '\n', '    struct Set {\n', '        // Storage of set values\n', '        bytes32[] _values;\n', '\n', '        // Position of the value in the `values` array, plus 1 because index 0\n', '        // means a value is not in the set.\n', '        mapping (bytes32 => uint256) _indexes;\n', '    }\n', '\n', '    /**\n', '     * @dev Add a value to a set. O(1).\n', '     *\n', '     * Returns true if the value was added to the set, that is if it was not\n', '     * already present.\n', '     */\n', '    function _add(Set storage set, bytes32 value) private returns (bool) {\n', '        if (!_contains(set, value)) {\n', '            set._values.push(value);\n', '            // The value is stored at length-1, but we add 1 to all indexes\n', '            // and use 0 as a sentinel value\n', '            set._indexes[value] = set._values.length;\n', '            return true;\n', '        } else {\n', '            return false;\n', '        }\n', '    }\n', '\n', '    /**\n', '     * @dev Removes a value from a set. O(1).\n', '     *\n', '     * Returns true if the value was removed from the set, that is if it was\n', '     * present.\n', '     */\n', '    function _remove(Set storage set, bytes32 value) private returns (bool) {\n', "        // We read and store the value's index to prevent multiple reads from the same storage slot\n", '        uint256 valueIndex = set._indexes[value];\n', '\n', '        if (valueIndex != 0) { // Equivalent to contains(set, value)\n', '            // To delete an element from the _values array in O(1), we swap the element to delete with the last one in\n', "            // the array, and then remove the last element (sometimes called as 'swap and pop').\n", '            // This modifies the order of the array, as noted in {at}.\n', '\n', '            uint256 toDeleteIndex = valueIndex - 1;\n', '            uint256 lastIndex = set._values.length - 1;\n', '\n', '            // When the value to delete is the last one, the swap operation is unnecessary. However, since this occurs\n', "            // so rarely, we still do the swap anyway to avoid the gas cost of adding an 'if' statement.\n", '\n', '            bytes32 lastvalue = set._values[lastIndex];\n', '\n', '            // Move the last value to the index where the value to delete is\n', '            set._values[toDeleteIndex] = lastvalue;\n', '            // Update the index for the moved value\n', '            set._indexes[lastvalue] = toDeleteIndex + 1; // All indexes are 1-based\n', '\n', '            // Delete the slot where the moved value was stored\n', '            set._values.pop();\n', '\n', '            // Delete the index for the deleted slot\n', '            delete set._indexes[value];\n', '\n', '            return true;\n', '        } else {\n', '            return false;\n', '        }\n', '    }\n', '\n', '    /**\n', '     * @dev Returns true if the value is in the set. O(1).\n', '     */\n', '    function _contains(Set storage set, bytes32 value) private view returns (bool) {\n', '        return set._indexes[value] != 0;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the number of values on the set. O(1).\n', '     */\n', '    function _length(Set storage set) private view returns (uint256) {\n', '        return set._values.length;\n', '    }\n', '\n', '   /**\n', '    * @dev Returns the value stored at position `index` in the set. O(1).\n', '    *\n', '    * Note that there are no guarantees on the ordering of values inside the\n', '    * array, and it may change when more values are added or removed.\n', '    *\n', '    * Requirements:\n', '    *\n', '    * - `index` must be strictly less than {length}.\n', '    */\n', '    function _at(Set storage set, uint256 index) private view returns (bytes32) {\n', '        require(set._values.length > index, "EnumerableSet: index out of bounds");\n', '        return set._values[index];\n', '    }\n', '\n', '    // AddressSet\n', '\n', '    struct AddressSet {\n', '        Set _inner;\n', '    }\n', '\n', '    /**\n', '     * @dev Add a value to a set. O(1).\n', '     *\n', '     * Returns true if the value was added to the set, that is if it was not\n', '     * already present.\n', '     */\n', '    function add(AddressSet storage set, address value) internal returns (bool) {\n', '        return _add(set._inner, bytes32(uint256(value)));\n', '    }\n', '\n', '    /**\n', '     * @dev Removes a value from a set. O(1).\n', '     *\n', '     * Returns true if the value was removed from the set, that is if it was\n', '     * present.\n', '     */\n', '    function remove(AddressSet storage set, address value) internal returns (bool) {\n', '        return _remove(set._inner, bytes32(uint256(value)));\n', '    }\n', '\n', '    /**\n', '     * @dev Returns true if the value is in the set. O(1).\n', '     */\n', '    function contains(AddressSet storage set, address value) internal view returns (bool) {\n', '        return _contains(set._inner, bytes32(uint256(value)));\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the number of values in the set. O(1).\n', '     */\n', '    function length(AddressSet storage set) internal view returns (uint256) {\n', '        return _length(set._inner);\n', '    }\n', '\n', '   /**\n', '    * @dev Returns the value stored at position `index` in the set. O(1).\n', '    *\n', '    * Note that there are no guarantees on the ordering of values inside the\n', '    * array, and it may change when more values are added or removed.\n', '    *\n', '    * Requirements:\n', '    *\n', '    * - `index` must be strictly less than {length}.\n', '    */\n', '    function at(AddressSet storage set, uint256 index) internal view returns (address) {\n', '        return address(uint256(_at(set._inner, index)));\n', '    }\n', ' }\n', '\n', 'contract Ownable {\n', '    \n', '    modifier onlyOwner() {\n', '        require(msg.sender==owner,"only owner allowed");\n', '        _;\n', '    }\n', '    \n', '    event OwnershipTransferred(\n', '        address indexed previousOwner,\n', '        address indexed newOwner\n', '    );\n', '    \n', '    \n', '    address payable owner;\n', '    address payable newOwner;\n', '\n', '    function changeOwner(address payable _newOwner) public onlyOwner {\n', '        require(_newOwner!=address(0));\n', '        newOwner = _newOwner;\n', '    }\n', '    \n', '    function acceptOwnership() public {\n', '        require(msg.sender == newOwner, "only new owner allowed");\n', '         emit OwnershipTransferred(\n', '            owner,\n', '            newOwner\n', '        );\n', '        owner = newOwner;\n', '        \n', '    }\n', '}\n', '\n', 'abstract contract ERC20 {\n', '    uint256 public totalSupply;\n', '    function balanceOf(address _owner) view public virtual returns (uint256 balance);\n', '    function transfer(address _to, uint256 _value) public virtual returns (bool success);\n', '    function transferFrom(address _from, address _to, uint256 _value) public virtual returns (bool success);\n', '    function approve(address _spender, uint256 _value) public virtual returns (bool success);\n', '    function allowance(address _owner, address _spender) view public virtual returns (uint256 remaining);\n', '    event Transfer(address indexed _from, address indexed _to, uint256 _value);\n', '    event Approval(address indexed _owner, address indexed _spender, uint256 _value);\n', '}\n', '\n', 'contract Token is Ownable,  ERC20 {\n', '    using EnumerableSet for EnumerableSet.AddressSet;\n', '    \n', '    string public symbol;\n', '    string public name;\n', '    uint8 public decimals;\n', '    \n', '    mapping (address=>uint256) balances;\n', '    mapping (address=>mapping (address=>uint256)) allowed;\n', '    \n', ' \n', '    uint256 public circulationSupply;\n', '    uint256 public stakeFarmSupply;\n', '    uint256 public teamAdvisorSupply;\n', '    uint256 public devFundSupply;\n', '    uint256 public marketingSupply;\n', '    uint256 public resverdSupply;\n', '    \n', '    uint256 public teamCounter; \n', '    uint256 public devFundCounter;\n', '    \n', '    mapping(uint256 => uint256) public  stakeFarmSupplyUnlockTime;\n', '    mapping(uint256 => uint256) public  stakeFarmUnlockSupply;\n', '    \n', '    mapping(uint256 => uint256) public  teamAdvisorSupplyUnlockTime;\n', '    mapping(uint256 => uint256) public  teamAdvisorSupplyUnlockSupply;\n', '    \n', '    mapping(uint256 => uint256) public  devFundSupplyUnlockTime;\n', '    mapping(uint256 => uint256) public  devFundSupplyUnlockSupply;\n', '    \n', '    mapping(uint256 => uint256) public  marketingSupplyUnlockTime;\n', '    mapping(uint256 => uint256) public  marketingUnlockSupply;\n', '    \n', '    mapping(uint256 => uint256) public  resverdSupplyUnlockTime;\n', '    mapping(uint256 => uint256) public  resverdUnlockSupply;\n', '    \n', '\t\n', '\tuint256 constant public maxSupply = 5000000 ether;\n', '\tuint256 constant public supplyPerYear =  1000000 ether;\n', '\tuint256 constant public oneYear = 31536000;\n', '\tuint256 constant public teamAdvisorPeriod = 5256000;\n', '\tuint256 constant public devFundPeriod = 2628000;\n', '\t\n', '\n', '    EnumerableSet.AddressSet private farmAddress;\n', '    address public stakeAddress;\n', '\n', '   \n', '    function balanceOf(address _owner) view public virtual override returns (uint256 balance) {return balances[_owner];}\n', '    \n', '    \n', '    function transfer(address _to, uint256 _amount) public virtual override returns (bool success) {\n', '      require (balances[msg.sender]>=_amount&&_amount>0&&balances[_to]+_amount>balances[_to]);\n', '      balances[msg.sender]-=_amount;\n', '      balances[_to]+=_amount;\n', '      emit Transfer(msg.sender,_to,_amount);\n', '      return true;\n', '    }\n', '  \n', '    function transferFrom(address _from,address _to,uint256 _amount) public virtual override returns (bool success) {\n', '      require (balances[_from]>=_amount&&allowed[_from][msg.sender]>=_amount&&_amount>0&&balances[_to]+_amount>balances[_to]);\n', '      balances[_from]-=_amount;\n', '      allowed[_from][msg.sender]-=_amount;\n', '      balances[_to]+=_amount;\n', '      emit Transfer(_from, _to, _amount);\n', '      return true;\n', '    }\n', '  \n', '    function approve(address _spender, uint256 _amount) public virtual override returns (bool success) {\n', '      allowed[msg.sender][_spender]=_amount;\n', '      emit Approval(msg.sender, _spender, _amount);\n', '      return true;\n', '    }\n', '    \n', '    function allowance(address _owner, address _spender) view public virtual override returns (uint256 remaining) {\n', '      return allowed[_owner][_spender];\n', '    }\n', '\n', '    function burn(uint256 _amount) public onlyOwner returns (bool success) {\n', '      require(_amount <= totalSupply, "The burning value cannot be greater than the Total Supply!");\n', '      address addressToBurn = 0x2323232323232323232323232323232323232323;\n', '      uint256 feeToOwner = _amount * 3 / 100; // 3%\n', '      transfer(addressToBurn, _amount - feeToOwner); // burn\n', '      transfer(owner, feeToOwner); // transfer to owner address\n', '      return true;\n', '    }\n', '\n', '    function mint(address _to, uint256 _amount) private returns (bool) {\n', '      require((_amount + totalSupply) <= maxSupply, "The total supply cannot exceed 5.000.000");\n', '      totalSupply = totalSupply + _amount;\n', '      balances[_to] = balances[_to] + _amount;\n', '      emit Transfer(address(0), _to, _amount);\n', '      return true;\n', '    }\n', '    \n', '    \n', '    function mintCirculationSupply(address to,uint256 _amount) external onlyOwner returns(bool){\n', '        require(circulationSupply >= _amount);    \n', '        mint(to,_amount);\n', '        circulationSupply -= _amount;\n', '        return true;\n', '    }\n', '    \n', '    function mintMarketingSupply(address to,uint256 _amount) external onlyOwner returns(bool){\n', '        for(uint i = 1;i <= 4 ; i++){\n', '            if(marketingSupplyUnlockTime[i] < now && marketingUnlockSupply[i] != 0){\n', '                marketingSupply += marketingUnlockSupply[i];\n', '                marketingUnlockSupply[i] = 0;\n', '            }\n', '            if(marketingSupplyUnlockTime[i] >  now)\n', '              break;\n', '        }\n', '        require(marketingSupply >= _amount);    \n', '        mint(to,_amount);\n', '        marketingSupply -= _amount;\n', '        return true;\n', '    }\n', '    \n', '    \n', '    function setFarmAddress(address[] memory _farm) external onlyOwner returns(bool){\n', '        for(uint256 i= 0 ;i< _farm.length;i++)\n', '        {\n', '            farmAddress.add(_farm[i]);\n', '        }\n', '        \n', '        return true;\n', '    }\n', '    \n', '    function setStakeAddress(address _stake) external onlyOwner returns(bool){\n', '        stakeAddress = _stake;\n', '        return true;\n', '    }\n', '    \n', '    function mintStakeFarmSupply(address to,uint256 _amount) external returns(uint256){\n', '        require(farmAddress.contains(msg.sender) || msg.sender == stakeAddress,"err farm or stake address only");\n', '        for(uint i = 1;i <= 4 ; i++){\n', '            if(stakeFarmSupplyUnlockTime[i] < now && stakeFarmUnlockSupply[i] != 0){\n', '                stakeFarmSupply += stakeFarmUnlockSupply[i];\n', '                stakeFarmUnlockSupply[i] = 0;\n', '            }\n', '            if(stakeFarmSupplyUnlockTime[i] >  now)\n', '              break;\n', '        }\n', '        if(_amount > stakeFarmSupply){\n', '            _amount = stakeFarmSupply;\n', '        }    \n', '        mint(to,_amount);\n', '        stakeFarmSupply -= _amount;\n', '        return _amount;\n', '    }\n', '    \n', '    \n', '    function mintReservedSupply(address to,uint256 _amount) external onlyOwner returns(bool){\n', '        for(uint i = 1;i <= 4 ; i++){\n', '            if(resverdSupplyUnlockTime[i] < now && resverdUnlockSupply[i] != 0){\n', '                resverdSupply += resverdUnlockSupply[i];\n', '                resverdUnlockSupply[i] = 0;\n', '            }\n', '            if(resverdSupplyUnlockTime[i] >  now)\n', '              break;\n', '        }\n', '        require(resverdSupply >= _amount);    \n', '        mint(to,_amount);\n', '        resverdSupply -= _amount;\n', '        return true;\n', '    }\n', '    \n', '    // for loop dont take too much cost as it only loop to 25\n', '    function mintDevFundSupply(address to,uint256 _amount) external onlyOwner returns(bool){\n', '        for(uint i = 1;i <= devFundCounter ; i++){\n', '            if(devFundSupplyUnlockTime[i] < now && devFundSupplyUnlockSupply[i] != 0){\n', '                devFundSupply += devFundSupplyUnlockSupply[i];\n', '                devFundSupplyUnlockSupply[i] = 0;\n', '            }\n', '            if(devFundSupplyUnlockTime[i] >  now)\n', '              break;\n', '        }\n', '        require(devFundSupply >= _amount);    \n', '        mint(to,_amount);\n', '        devFundSupply -= _amount;\n', '        return true;\n', '    }\n', '    \n', '    function mintTeamAdvisorFundSupply(address to,uint256 _amount) external onlyOwner returns(bool){\n', '        for(uint i = 1;i <= teamCounter ; i++){\n', '            if(teamAdvisorSupplyUnlockTime[i] < now && teamAdvisorSupplyUnlockSupply[i] != 0){\n', '                teamAdvisorSupply += teamAdvisorSupplyUnlockSupply[i];\n', '                teamAdvisorSupplyUnlockSupply[i] = 0;\n', '            }\n', '            if(teamAdvisorSupplyUnlockTime[i] >  now)\n', '              break;\n', '        }\n', '        require(teamAdvisorSupply >= _amount);    \n', '        mint(to,_amount);\n', '        teamAdvisorSupply -= _amount;\n', '        return true;\n', '    }\n', '\n', '    \n', '    \n', '    function _initSupply() internal returns (bool){\n', '        \n', '        circulationSupply = 370000 ether;\n', '        stakeFarmSupply =  350000 ether;\n', '        marketingSupply = 50000 ether;\n', '        resverdSupply = 10000 ether;\n', '        \n', '        uint256 currentTime = now;\n', '        uint256 tempAdvisor = 100000 ether;\n', '        uint256 tempDev = 120000 ether;\n', '    \n', '        for(uint j = 1;j <= 6 ; j++){\n', '            teamCounter+=1;\n', '            teamAdvisorSupplyUnlockTime[teamCounter] = currentTime+(teamAdvisorPeriod*j);\n', '            teamAdvisorSupplyUnlockSupply[teamCounter] = tempAdvisor/6;\n', '            \n', '        }\n', '        \n', '        for(uint k = 1;k <= 5 ; k++){\n', '            devFundCounter+= 1;\n', '            devFundSupplyUnlockTime[devFundCounter] = currentTime+(devFundPeriod*k);\n', '            devFundSupplyUnlockSupply[devFundCounter] = tempDev/5;\n', '            \n', '        }\n', '        \n', '        \n', '        for(uint i = 1;i <= 4 ; i++){\n', '            currentTime += oneYear;\n', '            \n', '            stakeFarmSupplyUnlockTime[i] = currentTime;\n', '            stakeFarmUnlockSupply[i] = 720000 ether;\n', '         \n', '            marketingSupplyUnlockTime[i] = currentTime;\n', '            marketingUnlockSupply[i] = 50000 ether;\n', '            \n', '            resverdSupplyUnlockTime[i] = currentTime;\n', '            resverdUnlockSupply[i] = 10000 ether;\n', '            \n', '            \n', '           for(uint j = 1;j <= 6 ; j++){\n', '                teamCounter+=1;\n', '                teamAdvisorSupplyUnlockTime[teamCounter] = currentTime+(teamAdvisorPeriod*j);\n', '                teamAdvisorSupplyUnlockSupply[teamCounter] = tempAdvisor/6;\n', '            \n', '           }\n', '        \n', '            for(uint k = 1;k <= 5 ; k++){\n', '                devFundCounter+= 1;\n', '                devFundSupplyUnlockTime[devFundCounter] = currentTime+(devFundPeriod*k);\n', '                devFundSupplyUnlockSupply[devFundCounter] = tempDev/5;\n', '                \n', '            }\n', '             \n', '        }\n', '            \n', ' \n', '    }\n', '   \n', '}\n', '\n', 'contract Remit is Token{\n', '    \n', '    \n', '    \n', '    constructor() public{\n', '      symbol = "REMIT";\n', '      name = "Remit";\n', '      decimals = 18;\n', '      totalSupply = 0;  \n', '      owner = msg.sender;\n', '      balances[owner] = totalSupply;\n', '      _initSupply();\n', '      \n', '    }\n', '    \n', '    \n', '\n', '    receive () payable external {\n', '      require(msg.value>0);\n', '      owner.transfer(msg.value);\n', '    }\n', '}']