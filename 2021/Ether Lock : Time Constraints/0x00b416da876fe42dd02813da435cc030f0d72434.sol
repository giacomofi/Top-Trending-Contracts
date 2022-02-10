['/**\n', ' *Submitted for verification at Etherscan.io on 2021-04-22\n', '*/\n', '\n', '// hevm: flattened sources of src/LerpFactory.sol\n', 'pragma solidity >=0.6.12 <0.7.0;\n', '\n', '////// src/Lerp.sol\n', '//\n', '/// Lerp.sol -- Linear Interpolation module\n', '//\n', '// This program is free software: you can redistribute it and/or modify\n', '// it under the terms of the GNU Affero General Public License as published by\n', '// the Free Software Foundation, either version 3 of the License, or\n', '// (at your option) any later version.\n', '//\n', '// This program is distributed in the hope that it will be useful,\n', '// but WITHOUT ANY WARRANTY; without even the implied warranty of\n', '// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the\n', '// GNU Affero General Public License for more details.\n', '//\n', '// You should have received a copy of the GNU Affero General Public License\n', '// along with this program.  If not, see <https://www.gnu.org/licenses/>.\n', '\n', '/* pragma solidity ^0.6.12; */\n', '\n', 'interface DenyLike {\n', '    function deny(address) external;\n', '}\n', '\n', 'interface FileLike {\n', '    function file(bytes32, uint256) external;\n', '}\n', '\n', 'interface FileIlkLike {\n', '    function file(bytes32, bytes32, uint256) external;\n', '}\n', '\n', '// Perform linear interpolation on a dss administrative value over time\n', '\n', 'abstract contract BaseLerp {\n', '\n', '    uint256 constant WAD = 10 ** 18;\n', '\n', '    address immutable public target;\n', '    bytes32 immutable public what;\n', '    uint256 immutable public start;\n', '    uint256 immutable public end;\n', '    uint256 immutable public duration;\n', '\n', '    bool              public done;\n', '    uint256           public startTime;\n', '\n', '    constructor(address target_, bytes32 what_, uint256 startTime_, uint256 start_, uint256 end_, uint256 duration_) public {\n', '        require(duration_ != 0, "Lerp/no-zero-duration");\n', '        require(duration_ <= 365 days, "Lerp/max-duration-one-year");\n', '        require(startTime_ <= block.timestamp + 365 days, "Lerp/start-within-one-year");\n', "        // This is not the exact upper bound, but it's a practical one\n", '        // Ballparked from 2^256 / 10^18 and verified that this is less than that value\n', '        require(start_ <= 10 ** 59, "Lerp/start-too-large");\n', '        require(end_ <= 10 ** 59, "Lerp/end-too-large");\n', '        target = target_;\n', '        what = what_;\n', '        startTime = startTime_;\n', '        start = start_;\n', '        end = end_;\n', '        duration = duration_;\n', '    }\n', '\n', '    function tick() external returns (uint256 result) {\n', '        require(!done, "Lerp/finished");\n', '        if (block.timestamp >= startTime) {\n', '            if (block.timestamp < startTime + duration) {\n', '                // All bounds are constrained in the constructor so no need for safe-math\n', '                // 0 <= t < WAD\n', '                uint256 t = (block.timestamp - startTime) * WAD / duration;\n', '                // y = (end - start) * t + start [Linear Interpolation]\n', '                //   = end * t + start - start * t [Avoids overflow by moving the subtraction to the end]\n', '                update(result = end * t / WAD + start - start * t / WAD);\n', '            } else {\n', '                // Set the end value and mark as done\n', '                update(result = end);\n', '                try DenyLike(target).deny(address(this)) {} catch {}\n', '                done = true;\n', '            }\n', '        }\n', '    }\n', '\n', '    function update(uint256 value) virtual internal;\n', '\n', '}\n', '\n', '// Standard Lerp with only a uint256 value\n', '\n', 'contract Lerp is BaseLerp {\n', '\n', '    constructor(address target_, bytes32 what_, uint256 startTime_, uint256 start_, uint256 end_, uint256 duration_) public BaseLerp(target_, what_, startTime_, start_, end_, duration_) {\n', '    }\n', '\n', '    function update(uint256 value) override internal {\n', '        FileLike(target).file(what, value);\n', '    }\n', '\n', '}\n', '\n', '// Lerp that takes an ilk parameter\n', '\n', 'contract IlkLerp is BaseLerp {\n', '\n', '    bytes32 immutable public ilk;\n', '\n', '    constructor(address target_, bytes32 ilk_, bytes32 what_, uint256 startTime_, uint256 start_, uint256 end_, uint256 duration_) public BaseLerp(target_, what_, startTime_, start_, end_, duration_) {\n', '        ilk = ilk_;\n', '    }\n', '\n', '    function update(uint256 value) override internal {\n', '        FileIlkLike(target).file(ilk, what, value);\n', '    }\n', '\n', '}\n', '\n', '////// src/LerpFactory.sol\n', '//\n', '/// LerpFactory.sol -- Linear Interpolation creation module\n', '//\n', '// This program is free software: you can redistribute it and/or modify\n', '// it under the terms of the GNU Affero General Public License as published by\n', '// the Free Software Foundation, either version 3 of the License, or\n', '// (at your option) any later version.\n', '//\n', '// This program is distributed in the hope that it will be useful,\n', '// but WITHOUT ANY WARRANTY; without even the implied warranty of\n', '// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the\n', '// GNU Affero General Public License for more details.\n', '//\n', '// You should have received a copy of the GNU Affero General Public License\n', '// along with this program.  If not, see <https://www.gnu.org/licenses/>.\n', '/* pragma solidity ^0.6.12; */\n', '\n', '/* import "./Lerp.sol"; */\n', '\n', 'contract LerpFactory {\n', '\n', '    // --- Auth ---\n', '    function rely(address guy) external auth { wards[guy] = 1; emit Rely(guy); }\n', '    function deny(address guy) external auth { wards[guy] = 0; emit Deny(guy); }\n', '    mapping (address => uint256) public wards;\n', '    modifier auth {\n', '        require(wards[msg.sender] == 1, "LerpFactory/not-authorized");\n', '        _;\n', '    }\n', '\n', '    mapping (bytes32 => address) public lerps;\n', '    address[] public active;  // Array of active lerps in no particular order\n', '\n', '    event Rely(address indexed usr);\n', '    event Deny(address indexed usr);\n', '    event NewLerp(bytes32 name, address indexed target, bytes32 what, uint256 startTime, uint256 start, uint256 end, uint256 duration);\n', '    event NewIlkLerp(bytes32 name, address indexed target, bytes32 ilk, bytes32 what, uint256 startTime, uint256 start, uint256 end, uint256 duration);\n', '    event LerpFinished(address indexed lerp);\n', '\n', '    constructor() public {\n', '        wards[msg.sender] = 1;\n', '        emit Rely(msg.sender);\n', '    }\n', '\n', '    function newLerp(bytes32 name_, address target_, bytes32 what_, uint256 startTime_, uint256 start_, uint256 end_, uint256 duration_) external auth returns (address lerp) {\n', '        lerp = address(new Lerp(target_, what_, startTime_, start_, end_, duration_));\n', '        lerps[name_] = lerp;\n', '        active.push(lerp);\n', '        \n', '        emit NewLerp(name_, target_, what_, startTime_, start_, end_, duration_);\n', '    }\n', '\n', '    function newIlkLerp(bytes32 name_, address target_, bytes32 ilk_, bytes32 what_, uint256 startTime_, uint256 start_, uint256 end_, uint256 duration_) external auth returns (address lerp) {\n', '        lerp = address(new IlkLerp(target_, ilk_, what_, startTime_, start_, end_, duration_));\n', '        lerps[name_] = lerp;\n', '        active.push(lerp);\n', '        \n', '        emit NewIlkLerp(name_, target_, ilk_, what_, startTime_, start_, end_, duration_);\n', '    }\n', '\n', '    function remove(uint256 index) internal {\n', '        address lerp = active[index];\n', '        if (index != active.length - 1) {\n', '            active[index] = active[active.length - 1];\n', '        }\n', '        active.pop();\n', '        \n', '        emit LerpFinished(lerp);\n', '    }\n', '\n', '    // Tick all active lerps or wipe them if they are done\n', '    function tall() external {\n', '        for (uint256 i = 0; i < active.length; i++) {\n', '            BaseLerp lerp = BaseLerp(active[i]);\n', '            try lerp.tick() {} catch {\n', '                // Stop tracking if this lerp fails\n', '                remove(i);\n', '                i--;\n', '            }\n', '            if (lerp.done()) {\n', '                remove(i);\n', '                i--;\n', '            }\n', '        }\n', '    }\n', '\n', '    // The number of active lerps\n', '    function count() external view returns (uint256) {\n', '        return active.length;\n', '    }\n', '\n', '    // Return the entire array of active lerps\n', '    function list() external view returns (address[] memory) {\n', '        return active;\n', '    }\n', '\n', '}']