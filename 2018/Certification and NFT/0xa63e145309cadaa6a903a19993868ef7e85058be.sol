['// hevm: flattened sources of src/VoteProxyFactory.sol\n', 'pragma solidity ^0.4.24;\n', '\n', '////// lib/ds-token/lib/ds-stop/lib/ds-auth/src/auth.sol\n', '// This program is free software: you can redistribute it and/or modify\n', '// it under the terms of the GNU General Public License as published by\n', '// the Free Software Foundation, either version 3 of the License, or\n', '// (at your option) any later version.\n', '\n', '// This program is distributed in the hope that it will be useful,\n', '// but WITHOUT ANY WARRANTY; without even the implied warranty of\n', '// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the\n', '// GNU General Public License for more details.\n', '\n', '// You should have received a copy of the GNU General Public License\n', '// along with this program.  If not, see <http://www.gnu.org/licenses/>.\n', '\n', '/* pragma solidity ^0.4.23; */\n', '\n', 'contract DSAuthority {\n', '    function canCall(\n', '        address src, address dst, bytes4 sig\n', '    ) public view returns (bool);\n', '}\n', '\n', 'contract DSAuthEvents {\n', '    event LogSetAuthority (address indexed authority);\n', '    event LogSetOwner     (address indexed owner);\n', '}\n', '\n', 'contract DSAuth is DSAuthEvents {\n', '    DSAuthority  public  authority;\n', '    address      public  owner;\n', '\n', '    constructor() public {\n', '        owner = msg.sender;\n', '        emit LogSetOwner(msg.sender);\n', '    }\n', '\n', '    function setOwner(address owner_)\n', '        public\n', '        auth\n', '    {\n', '        owner = owner_;\n', '        emit LogSetOwner(owner);\n', '    }\n', '\n', '    function setAuthority(DSAuthority authority_)\n', '        public\n', '        auth\n', '    {\n', '        authority = authority_;\n', '        emit LogSetAuthority(authority);\n', '    }\n', '\n', '    modifier auth {\n', '        require(isAuthorized(msg.sender, msg.sig));\n', '        _;\n', '    }\n', '\n', '    function isAuthorized(address src, bytes4 sig) internal view returns (bool) {\n', '        if (src == address(this)) {\n', '            return true;\n', '        } else if (src == owner) {\n', '            return true;\n', '        } else if (authority == DSAuthority(0)) {\n', '            return false;\n', '        } else {\n', '            return authority.canCall(src, this, sig);\n', '        }\n', '    }\n', '}\n', '\n', '////// lib/ds-chief/lib/ds-roles/src/roles.sol\n', '// roles.sol - roled based authentication\n', '\n', '// Copyright (C) 2017  DappHub, LLC\n', '\n', '// This program is free software: you can redistribute it and/or modify\n', '// it under the terms of the GNU General Public License as published by\n', '// the Free Software Foundation, either version 3 of the License, or\n', '// (at your option) any later version.\n', '\n', '// This program is distributed in the hope that it will be useful,\n', '// but WITHOUT ANY WARRANTY; without even the implied warranty of\n', '// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the\n', '// GNU General Public License for more details.\n', '\n', '// You should have received a copy of the GNU General Public License\n', '// along with this program.  If not, see <http://www.gnu.org/licenses/>.\n', '\n', '/* pragma solidity ^0.4.13; */\n', '\n', "/* import 'ds-auth/auth.sol'; */\n", '\n', 'contract DSRoles is DSAuth, DSAuthority\n', '{\n', '    mapping(address=>bool) _root_users;\n', '    mapping(address=>bytes32) _user_roles;\n', '    mapping(address=>mapping(bytes4=>bytes32)) _capability_roles;\n', '    mapping(address=>mapping(bytes4=>bool)) _public_capabilities;\n', '\n', '    function getUserRoles(address who)\n', '        public\n', '        view\n', '        returns (bytes32)\n', '    {\n', '        return _user_roles[who];\n', '    }\n', '\n', '    function getCapabilityRoles(address code, bytes4 sig)\n', '        public\n', '        view\n', '        returns (bytes32)\n', '    {\n', '        return _capability_roles[code][sig];\n', '    }\n', '\n', '    function isUserRoot(address who)\n', '        public\n', '        view\n', '        returns (bool)\n', '    {\n', '        return _root_users[who];\n', '    }\n', '\n', '    function isCapabilityPublic(address code, bytes4 sig)\n', '        public\n', '        view\n', '        returns (bool)\n', '    {\n', '        return _public_capabilities[code][sig];\n', '    }\n', '\n', '    function hasUserRole(address who, uint8 role)\n', '        public\n', '        view\n', '        returns (bool)\n', '    {\n', '        bytes32 roles = getUserRoles(who);\n', '        bytes32 shifted = bytes32(uint256(uint256(2) ** uint256(role)));\n', '        return bytes32(0) != roles & shifted;\n', '    }\n', '\n', '    function canCall(address caller, address code, bytes4 sig)\n', '        public\n', '        view\n', '        returns (bool)\n', '    {\n', '        if( isUserRoot(caller) || isCapabilityPublic(code, sig) ) {\n', '            return true;\n', '        } else {\n', '            bytes32 has_roles = getUserRoles(caller);\n', '            bytes32 needs_one_of = getCapabilityRoles(code, sig);\n', '            return bytes32(0) != has_roles & needs_one_of;\n', '        }\n', '    }\n', '\n', '    function BITNOT(bytes32 input) internal pure returns (bytes32 output) {\n', '        return (input ^ bytes32(uint(-1)));\n', '    }\n', '\n', '    function setRootUser(address who, bool enabled)\n', '        public\n', '        auth\n', '    {\n', '        _root_users[who] = enabled;\n', '    }\n', '\n', '    function setUserRole(address who, uint8 role, bool enabled)\n', '        public\n', '        auth\n', '    {\n', '        bytes32 last_roles = _user_roles[who];\n', '        bytes32 shifted = bytes32(uint256(uint256(2) ** uint256(role)));\n', '        if( enabled ) {\n', '            _user_roles[who] = last_roles | shifted;\n', '        } else {\n', '            _user_roles[who] = last_roles & BITNOT(shifted);\n', '        }\n', '    }\n', '\n', '    function setPublicCapability(address code, bytes4 sig, bool enabled)\n', '        public\n', '        auth\n', '    {\n', '        _public_capabilities[code][sig] = enabled;\n', '    }\n', '\n', '    function setRoleCapability(uint8 role, address code, bytes4 sig, bool enabled)\n', '        public\n', '        auth\n', '    {\n', '        bytes32 last_roles = _capability_roles[code][sig];\n', '        bytes32 shifted = bytes32(uint256(uint256(2) ** uint256(role)));\n', '        if( enabled ) {\n', '            _capability_roles[code][sig] = last_roles | shifted;\n', '        } else {\n', '            _capability_roles[code][sig] = last_roles & BITNOT(shifted);\n', '        }\n', '\n', '    }\n', '\n', '}\n', '\n', '////// lib/ds-token/lib/ds-math/src/math.sol\n', '/// math.sol -- mixin for inline numerical wizardry\n', '\n', '// This program is free software: you can redistribute it and/or modify\n', '// it under the terms of the GNU General Public License as published by\n', '// the Free Software Foundation, either version 3 of the License, or\n', '// (at your option) any later version.\n', '\n', '// This program is distributed in the hope that it will be useful,\n', '// but WITHOUT ANY WARRANTY; without even the implied warranty of\n', '// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the\n', '// GNU General Public License for more details.\n', '\n', '// You should have received a copy of the GNU General Public License\n', '// along with this program.  If not, see <http://www.gnu.org/licenses/>.\n', '\n', '/* pragma solidity ^0.4.13; */\n', '\n', 'contract DSMath {\n', '    function add(uint x, uint y) internal pure returns (uint z) {\n', '        require((z = x + y) >= x);\n', '    }\n', '    function sub(uint x, uint y) internal pure returns (uint z) {\n', '        require((z = x - y) <= x);\n', '    }\n', '    function mul(uint x, uint y) internal pure returns (uint z) {\n', '        require(y == 0 || (z = x * y) / y == x);\n', '    }\n', '\n', '    function min(uint x, uint y) internal pure returns (uint z) {\n', '        return x <= y ? x : y;\n', '    }\n', '    function max(uint x, uint y) internal pure returns (uint z) {\n', '        return x >= y ? x : y;\n', '    }\n', '    function imin(int x, int y) internal pure returns (int z) {\n', '        return x <= y ? x : y;\n', '    }\n', '    function imax(int x, int y) internal pure returns (int z) {\n', '        return x >= y ? x : y;\n', '    }\n', '\n', '    uint constant WAD = 10 ** 18;\n', '    uint constant RAY = 10 ** 27;\n', '\n', '    function wmul(uint x, uint y) internal pure returns (uint z) {\n', '        z = add(mul(x, y), WAD / 2) / WAD;\n', '    }\n', '    function rmul(uint x, uint y) internal pure returns (uint z) {\n', '        z = add(mul(x, y), RAY / 2) / RAY;\n', '    }\n', '    function wdiv(uint x, uint y) internal pure returns (uint z) {\n', '        z = add(mul(x, WAD), y / 2) / y;\n', '    }\n', '    function rdiv(uint x, uint y) internal pure returns (uint z) {\n', '        z = add(mul(x, RAY), y / 2) / y;\n', '    }\n', '\n', '    // This famous algorithm is called "exponentiation by squaring"\n', '    // and calculates x^n with x as fixed-point and n as regular unsigned.\n', '    //\n', "    // It's O(log n), instead of O(n) for naive repeated multiplication.\n", '    //\n', '    // These facts are why it works:\n', '    //\n', '    //  If n is even, then x^n = (x^2)^(n/2).\n', '    //  If n is odd,  then x^n = x * x^(n-1),\n', '    //   and applying the equation for even x gives\n', '    //    x^n = x * (x^2)^((n-1) / 2).\n', '    //\n', '    //  Also, EVM division is flooring and\n', '    //    floor[(n-1) / 2] = floor[n / 2].\n', '    //\n', '    function rpow(uint x, uint n) internal pure returns (uint z) {\n', '        z = n % 2 != 0 ? x : RAY;\n', '\n', '        for (n /= 2; n != 0; n /= 2) {\n', '            x = rmul(x, x);\n', '\n', '            if (n % 2 != 0) {\n', '                z = rmul(z, x);\n', '            }\n', '        }\n', '    }\n', '}\n', '\n', '////// lib/ds-token/lib/ds-stop/lib/ds-note/src/note.sol\n', "/// note.sol -- the `note' modifier, for logging calls as events\n", '\n', '// This program is free software: you can redistribute it and/or modify\n', '// it under the terms of the GNU General Public License as published by\n', '// the Free Software Foundation, either version 3 of the License, or\n', '// (at your option) any later version.\n', '\n', '// This program is distributed in the hope that it will be useful,\n', '// but WITHOUT ANY WARRANTY; without even the implied warranty of\n', '// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the\n', '// GNU General Public License for more details.\n', '\n', '// You should have received a copy of the GNU General Public License\n', '// along with this program.  If not, see <http://www.gnu.org/licenses/>.\n', '\n', '/* pragma solidity ^0.4.23; */\n', '\n', 'contract DSNote {\n', '    event LogNote(\n', '        bytes4   indexed  sig,\n', '        address  indexed  guy,\n', '        bytes32  indexed  foo,\n', '        bytes32  indexed  bar,\n', '        uint              wad,\n', '        bytes             fax\n', '    ) anonymous;\n', '\n', '    modifier note {\n', '        bytes32 foo;\n', '        bytes32 bar;\n', '\n', '        assembly {\n', '            foo := calldataload(4)\n', '            bar := calldataload(36)\n', '        }\n', '\n', '        emit LogNote(msg.sig, msg.sender, foo, bar, msg.value, msg.data);\n', '\n', '        _;\n', '    }\n', '}\n', '\n', '////// lib/ds-chief/lib/ds-thing/src/thing.sol\n', '// thing.sol - `auth` with handy mixins. your things should be DSThings\n', '\n', '// Copyright (C) 2017  DappHub, LLC\n', '\n', '// This program is free software: you can redistribute it and/or modify\n', '// it under the terms of the GNU General Public License as published by\n', '// the Free Software Foundation, either version 3 of the License, or\n', '// (at your option) any later version.\n', '\n', '// This program is distributed in the hope that it will be useful,\n', '// but WITHOUT ANY WARRANTY; without even the implied warranty of\n', '// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the\n', '// GNU General Public License for more details.\n', '\n', '// You should have received a copy of the GNU General Public License\n', '// along with this program.  If not, see <http://www.gnu.org/licenses/>.\n', '\n', '/* pragma solidity ^0.4.23; */\n', '\n', "/* import 'ds-auth/auth.sol'; */\n", "/* import 'ds-note/note.sol'; */\n", "/* import 'ds-math/math.sol'; */\n", '\n', 'contract DSThing is DSAuth, DSNote, DSMath {\n', '\n', '    function S(string s) internal pure returns (bytes4) {\n', '        return bytes4(keccak256(abi.encodePacked(s)));\n', '    }\n', '\n', '}\n', '\n', '////// lib/ds-token/lib/ds-stop/src/stop.sol\n', '/// stop.sol -- mixin for enable/disable functionality\n', '\n', '// Copyright (C) 2017  DappHub, LLC\n', '\n', '// This program is free software: you can redistribute it and/or modify\n', '// it under the terms of the GNU General Public License as published by\n', '// the Free Software Foundation, either version 3 of the License, or\n', '// (at your option) any later version.\n', '\n', '// This program is distributed in the hope that it will be useful,\n', '// but WITHOUT ANY WARRANTY; without even the implied warranty of\n', '// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the\n', '// GNU General Public License for more details.\n', '\n', '// You should have received a copy of the GNU General Public License\n', '// along with this program.  If not, see <http://www.gnu.org/licenses/>.\n', '\n', '/* pragma solidity ^0.4.23; */\n', '\n', '/* import "ds-auth/auth.sol"; */\n', '/* import "ds-note/note.sol"; */\n', '\n', 'contract DSStop is DSNote, DSAuth {\n', '\n', '    bool public stopped;\n', '\n', '    modifier stoppable {\n', '        require(!stopped);\n', '        _;\n', '    }\n', '    function stop() public auth note {\n', '        stopped = true;\n', '    }\n', '    function start() public auth note {\n', '        stopped = false;\n', '    }\n', '\n', '}\n', '\n', '////// lib/ds-token/lib/erc20/src/erc20.sol\n', '/// erc20.sol -- API for the ERC20 token standard\n', '\n', '// See <https://github.com/ethereum/EIPs/issues/20>.\n', '\n', '// This file likely does not meet the threshold of originality\n', '// required for copyright to apply.  As a result, this is free and\n', '// unencumbered software belonging to the public domain.\n', '\n', '/* pragma solidity ^0.4.8; */\n', '\n', 'contract ERC20Events {\n', '    event Approval(address indexed src, address indexed guy, uint wad);\n', '    event Transfer(address indexed src, address indexed dst, uint wad);\n', '}\n', '\n', 'contract ERC20 is ERC20Events {\n', '    function totalSupply() public view returns (uint);\n', '    function balanceOf(address guy) public view returns (uint);\n', '    function allowance(address src, address guy) public view returns (uint);\n', '\n', '    function approve(address guy, uint wad) public returns (bool);\n', '    function transfer(address dst, uint wad) public returns (bool);\n', '    function transferFrom(\n', '        address src, address dst, uint wad\n', '    ) public returns (bool);\n', '}\n', '\n', '////// lib/ds-token/src/base.sol\n', '/// base.sol -- basic ERC20 implementation\n', '\n', '// Copyright (C) 2015, 2016, 2017  DappHub, LLC\n', '\n', '// This program is free software: you can redistribute it and/or modify\n', '// it under the terms of the GNU General Public License as published by\n', '// the Free Software Foundation, either version 3 of the License, or\n', '// (at your option) any later version.\n', '\n', '// This program is distributed in the hope that it will be useful,\n', '// but WITHOUT ANY WARRANTY; without even the implied warranty of\n', '// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the\n', '// GNU General Public License for more details.\n', '\n', '// You should have received a copy of the GNU General Public License\n', '// along with this program.  If not, see <http://www.gnu.org/licenses/>.\n', '\n', '/* pragma solidity ^0.4.23; */\n', '\n', '/* import "erc20/erc20.sol"; */\n', '/* import "ds-math/math.sol"; */\n', '\n', 'contract DSTokenBase is ERC20, DSMath {\n', '    uint256                                            _supply;\n', '    mapping (address => uint256)                       _balances;\n', '    mapping (address => mapping (address => uint256))  _approvals;\n', '\n', '    constructor(uint supply) public {\n', '        _balances[msg.sender] = supply;\n', '        _supply = supply;\n', '    }\n', '\n', '    function totalSupply() public view returns (uint) {\n', '        return _supply;\n', '    }\n', '    function balanceOf(address src) public view returns (uint) {\n', '        return _balances[src];\n', '    }\n', '    function allowance(address src, address guy) public view returns (uint) {\n', '        return _approvals[src][guy];\n', '    }\n', '\n', '    function transfer(address dst, uint wad) public returns (bool) {\n', '        return transferFrom(msg.sender, dst, wad);\n', '    }\n', '\n', '    function transferFrom(address src, address dst, uint wad)\n', '        public\n', '        returns (bool)\n', '    {\n', '        if (src != msg.sender) {\n', '            _approvals[src][msg.sender] = sub(_approvals[src][msg.sender], wad);\n', '        }\n', '\n', '        _balances[src] = sub(_balances[src], wad);\n', '        _balances[dst] = add(_balances[dst], wad);\n', '\n', '        emit Transfer(src, dst, wad);\n', '\n', '        return true;\n', '    }\n', '\n', '    function approve(address guy, uint wad) public returns (bool) {\n', '        _approvals[msg.sender][guy] = wad;\n', '\n', '        emit Approval(msg.sender, guy, wad);\n', '\n', '        return true;\n', '    }\n', '}\n', '\n', '////// lib/ds-token/src/token.sol\n', '/// token.sol -- ERC20 implementation with minting and burning\n', '\n', '// Copyright (C) 2015, 2016, 2017  DappHub, LLC\n', '\n', '// This program is free software: you can redistribute it and/or modify\n', '// it under the terms of the GNU General Public License as published by\n', '// the Free Software Foundation, either version 3 of the License, or\n', '// (at your option) any later version.\n', '\n', '// This program is distributed in the hope that it will be useful,\n', '// but WITHOUT ANY WARRANTY; without even the implied warranty of\n', '// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the\n', '// GNU General Public License for more details.\n', '\n', '// You should have received a copy of the GNU General Public License\n', '// along with this program.  If not, see <http://www.gnu.org/licenses/>.\n', '\n', '/* pragma solidity ^0.4.23; */\n', '\n', '/* import "ds-stop/stop.sol"; */\n', '\n', '/* import "./base.sol"; */\n', '\n', 'contract DSToken is DSTokenBase(0), DSStop {\n', '\n', '    bytes32  public  symbol;\n', '    uint256  public  decimals = 18; // standard token precision. override to customize\n', '\n', '    constructor(bytes32 symbol_) public {\n', '        symbol = symbol_;\n', '    }\n', '\n', '    event Mint(address indexed guy, uint wad);\n', '    event Burn(address indexed guy, uint wad);\n', '\n', '    function approve(address guy) public stoppable returns (bool) {\n', '        return super.approve(guy, uint(-1));\n', '    }\n', '\n', '    function approve(address guy, uint wad) public stoppable returns (bool) {\n', '        return super.approve(guy, wad);\n', '    }\n', '\n', '    function transferFrom(address src, address dst, uint wad)\n', '        public\n', '        stoppable\n', '        returns (bool)\n', '    {\n', '        if (src != msg.sender && _approvals[src][msg.sender] != uint(-1)) {\n', '            _approvals[src][msg.sender] = sub(_approvals[src][msg.sender], wad);\n', '        }\n', '\n', '        _balances[src] = sub(_balances[src], wad);\n', '        _balances[dst] = add(_balances[dst], wad);\n', '\n', '        emit Transfer(src, dst, wad);\n', '\n', '        return true;\n', '    }\n', '\n', '    function push(address dst, uint wad) public {\n', '        transferFrom(msg.sender, dst, wad);\n', '    }\n', '    function pull(address src, uint wad) public {\n', '        transferFrom(src, msg.sender, wad);\n', '    }\n', '    function move(address src, address dst, uint wad) public {\n', '        transferFrom(src, dst, wad);\n', '    }\n', '\n', '    function mint(uint wad) public {\n', '        mint(msg.sender, wad);\n', '    }\n', '    function burn(uint wad) public {\n', '        burn(msg.sender, wad);\n', '    }\n', '    function mint(address guy, uint wad) public auth stoppable {\n', '        _balances[guy] = add(_balances[guy], wad);\n', '        _supply = add(_supply, wad);\n', '        emit Mint(guy, wad);\n', '    }\n', '    function burn(address guy, uint wad) public auth stoppable {\n', '        if (guy != msg.sender && _approvals[guy][msg.sender] != uint(-1)) {\n', '            _approvals[guy][msg.sender] = sub(_approvals[guy][msg.sender], wad);\n', '        }\n', '\n', '        _balances[guy] = sub(_balances[guy], wad);\n', '        _supply = sub(_supply, wad);\n', '        emit Burn(guy, wad);\n', '    }\n', '\n', '    // Optional token name\n', '    bytes32   public  name = "";\n', '\n', '    function setName(bytes32 name_) public auth {\n', '        name = name_;\n', '    }\n', '}\n', '\n', '////// lib/ds-chief/src/chief.sol\n', '// chief.sol - select an authority by consensus\n', '\n', '// Copyright (C) 2017  DappHub, LLC\n', '\n', '// This program is free software: you can redistribute it and/or modify\n', '// it under the terms of the GNU General Public License as published by\n', '// the Free Software Foundation, either version 3 of the License, or\n', '// (at your option) any later version.\n', '\n', '// This program is distributed in the hope that it will be useful,\n', '// but WITHOUT ANY WARRANTY; without even the implied warranty of\n', '// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the\n', '// GNU General Public License for more details.\n', '\n', '// You should have received a copy of the GNU General Public License\n', '// along with this program.  If not, see <http://www.gnu.org/licenses/>.\n', '\n', '/* pragma solidity ^0.4.23; */\n', '\n', "/* import 'ds-token/token.sol'; */\n", "/* import 'ds-roles/roles.sol'; */\n", "/* import 'ds-thing/thing.sol'; */\n", '\n', '// The right way to use this contract is probably to mix it with some kind\n', '// of `DSAuthority`, like with `ds-roles`.\n', '//   SEE DSChief\n', 'contract DSChiefApprovals is DSThing {\n', '    mapping(bytes32=>address[]) public slates;\n', '    mapping(address=>bytes32) public votes;\n', '    mapping(address=>uint256) public approvals;\n', '    mapping(address=>uint256) public deposits;\n', '    DSToken public GOV; // voting token that gets locked up\n', '    DSToken public IOU; // non-voting representation of a token, for e.g. secondary voting mechanisms\n', "    address public hat; // the chieftain's hat\n", '\n', '    uint256 public MAX_YAYS;\n', '\n', '    event Etch(bytes32 indexed slate);\n', '\n', '    // IOU constructed outside this contract reduces deployment costs significantly\n', '    // lock/free/vote are quite sensitive to token invariants. Caution is advised.\n', '    constructor(DSToken GOV_, DSToken IOU_, uint MAX_YAYS_) public\n', '    {\n', '        GOV = GOV_;\n', '        IOU = IOU_;\n', '        MAX_YAYS = MAX_YAYS_;\n', '    }\n', '\n', '    function lock(uint wad)\n', '        public\n', '        note\n', '    {\n', '        GOV.pull(msg.sender, wad);\n', '        IOU.mint(msg.sender, wad);\n', '        deposits[msg.sender] = add(deposits[msg.sender], wad);\n', '        addWeight(wad, votes[msg.sender]);\n', '    }\n', '\n', '    function free(uint wad)\n', '        public\n', '        note\n', '    {\n', '        deposits[msg.sender] = sub(deposits[msg.sender], wad);\n', '        subWeight(wad, votes[msg.sender]);\n', '        IOU.burn(msg.sender, wad);\n', '        GOV.push(msg.sender, wad);\n', '    }\n', '\n', '    function etch(address[] yays)\n', '        public\n', '        note\n', '        returns (bytes32 slate)\n', '    {\n', '        require( yays.length <= MAX_YAYS );\n', '        requireByteOrderedSet(yays);\n', '\n', '        bytes32 hash = keccak256(abi.encodePacked(yays));\n', '        slates[hash] = yays;\n', '        emit Etch(hash);\n', '        return hash;\n', '    }\n', '\n', '    function vote(address[] yays) public returns (bytes32)\n', '        // note  both sub-calls note\n', '    {\n', '        bytes32 slate = etch(yays);\n', '        vote(slate);\n', '        return slate;\n', '    }\n', '\n', '    function vote(bytes32 slate)\n', '        public\n', '        note\n', '    {\n', '        uint weight = deposits[msg.sender];\n', '        subWeight(weight, votes[msg.sender]);\n', '        votes[msg.sender] = slate;\n', '        addWeight(weight, votes[msg.sender]);\n', '    }\n', '\n', '    // like `drop`/`swap` except simply "elect this address if it is higher than current hat"\n', '    function lift(address whom)\n', '        public\n', '        note\n', '    {\n', '        require(approvals[whom] > approvals[hat]);\n', '        hat = whom;\n', '    }\n', '\n', '    function addWeight(uint weight, bytes32 slate)\n', '        internal\n', '    {\n', '        address[] storage yays = slates[slate];\n', '        for( uint i = 0; i < yays.length; i++) {\n', '            approvals[yays[i]] = add(approvals[yays[i]], weight);\n', '        }\n', '    }\n', '\n', '    function subWeight(uint weight, bytes32 slate)\n', '        internal\n', '    {\n', '        address[] storage yays = slates[slate];\n', '        for( uint i = 0; i < yays.length; i++) {\n', '            approvals[yays[i]] = sub(approvals[yays[i]], weight);\n', '        }\n', '    }\n', '\n', '    // Throws unless the array of addresses is a ordered set.\n', '    function requireByteOrderedSet(address[] yays)\n', '        internal\n', '        pure\n', '    {\n', '        if( yays.length == 0 || yays.length == 1 ) {\n', '            return;\n', '        }\n', '        for( uint i = 0; i < yays.length - 1; i++ ) {\n', '            // strict inequality ensures both ordering and uniqueness\n', '            require(uint(bytes32(yays[i])) < uint256(bytes32(yays[i+1])));\n', '        }\n', '    }\n', '}\n', '\n', '\n', '// `hat` address is unique root user (has every role) and the\n', "// unique owner of role 0 (typically 'sys' or 'internal')\n", 'contract DSChief is DSRoles, DSChiefApprovals {\n', '\n', '    constructor(DSToken GOV, DSToken IOU, uint MAX_YAYS)\n', '             DSChiefApprovals (GOV, IOU, MAX_YAYS)\n', '        public\n', '    {\n', '        authority = this;\n', '        owner = 0;\n', '    }\n', '\n', '    function setOwner(address owner_) public {\n', '        owner_;\n', '        revert();\n', '    }\n', '\n', '    function setAuthority(DSAuthority authority_) public {\n', '        authority_;\n', '        revert();\n', '    }\n', '\n', '    function isUserRoot(address who)\n', '        public\n', '        constant\n', '        returns (bool)\n', '    {\n', '        return (who == hat);\n', '    }\n', '    function setRootUser(address who, bool enabled) public {\n', '        who; enabled;\n', '        revert();\n', '    }\n', '}\n', '\n', 'contract DSChiefFab {\n', '    function newChief(DSToken gov, uint MAX_YAYS) public returns (DSChief chief) {\n', "        DSToken iou = new DSToken('IOU');\n", '        chief = new DSChief(gov, iou, MAX_YAYS);\n', '        iou.setOwner(chief);\n', '    }\n', '}\n', '\n', '////// src/VoteProxy.sol\n', '// VoteProxy - vote w/ a hot or cold wallet using a proxy identity\n', '/* pragma solidity ^0.4.24; */\n', '\n', '/* import "ds-token/token.sol"; */\n', '/* import "ds-chief/chief.sol"; */\n', '\n', 'contract VoteProxy {\n', '    address public cold;\n', '    address public hot;\n', '    DSToken public gov;\n', '    DSToken public iou;\n', '    DSChief public chief;\n', '\n', '    constructor(DSChief _chief, address _cold, address _hot) public {\n', '        chief = _chief;\n', '        cold = _cold;\n', '        hot = _hot;\n', '        \n', '        gov = chief.GOV();\n', '        iou = chief.IOU();\n', '        gov.approve(chief, uint256(-1));\n', '        iou.approve(chief, uint256(-1));\n', '    }\n', '\n', '    modifier auth() {\n', '        require(msg.sender == hot || msg.sender == cold, "Sender must be a Cold or Hot Wallet");\n', '        _;\n', '    }\n', '    \n', '    function lock(uint256 wad) public auth {\n', '        gov.pull(cold, wad);   // mkr from cold\n', '        chief.lock(wad);       // mkr out, ious in\n', '    }\n', '\n', '    function free(uint256 wad) public auth {\n', '        chief.free(wad);       // ious out, mkr in\n', '        gov.push(cold, wad);   // mkr to cold\n', '    }\n', '\n', '    function freeAll() public auth {\n', '        chief.free(chief.deposits(this));            \n', '        gov.push(cold, gov.balanceOf(this)); \n', '    }\n', '\n', '    function vote(address[] yays) public auth returns (bytes32) {\n', '        return chief.vote(yays);\n', '    }\n', '\n', '    function vote(bytes32 slate) public auth {\n', '        chief.vote(slate);\n', '    }\n', '}\n', '\n', '////// src/VoteProxyFactory.sol\n', '// VoteProxyFactory - create and keep record of proxy identities\n', '/* pragma solidity ^0.4.24; */\n', '\n', '/* import "./VoteProxy.sol"; */\n', '\n', 'contract VoteProxyFactory {\n', '    DSChief public chief;\n', '    mapping(address => VoteProxy) public hotMap;\n', '    mapping(address => VoteProxy) public coldMap;\n', '    mapping(address => address) public linkRequests;\n', '\n', '    event LinkRequested(address indexed cold, address indexed hot);\n', '    event LinkConfirmed(address indexed cold, address indexed hot, address indexed voteProxy);\n', '    \n', '    constructor(DSChief chief_) public { chief = chief_; }\n', '\n', '    function hasProxy(address guy) public view returns (bool) {\n', '        return (coldMap[guy] != address(0) || hotMap[guy] != address(0));\n', '    }\n', '\n', '    function initiateLink(address hot) public {\n', '        require(!hasProxy(msg.sender), "Cold wallet is already linked to another Vote Proxy");\n', '        require(!hasProxy(hot), "Hot wallet is already linked to another Vote Proxy");\n', '\n', '        linkRequests[msg.sender] = hot;\n', '        emit LinkRequested(msg.sender, hot);\n', '    }\n', '\n', '    function approveLink(address cold) public returns (VoteProxy voteProxy) {\n', '        require(linkRequests[cold] == msg.sender, "Cold wallet must initiate a link first");\n', '        require(!hasProxy(msg.sender), "Hot wallet is already linked to another Vote Proxy");\n', '\n', '        voteProxy = new VoteProxy(chief, cold, msg.sender);\n', '        hotMap[msg.sender] = voteProxy;\n', '        coldMap[cold] = voteProxy;\n', '        delete linkRequests[cold];\n', '        emit LinkConfirmed(cold, msg.sender, voteProxy);\n', '    }\n', '\n', '    function breakLink() public {\n', '        require(hasProxy(msg.sender), "No VoteProxy found for this sender");\n', '\n', '        VoteProxy voteProxy = coldMap[msg.sender] != address(0)\n', '            ? coldMap[msg.sender] : hotMap[msg.sender];\n', '        address cold = voteProxy.cold();\n', '        address hot = voteProxy.hot();\n', '        require(chief.deposits(voteProxy) == 0, "VoteProxy still has funds attached to it");\n', '\n', '        delete coldMap[cold];\n', '        delete hotMap[hot];\n', '    }\n', '\n', '    function linkSelf() public returns (VoteProxy voteProxy) {\n', '        initiateLink(msg.sender);\n', '        return approveLink(msg.sender);\n', '    }\n', '}']