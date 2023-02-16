// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "lib/openzeppelin-contracts/contracts/proxy/ERC1967/ERC1967Proxy.sol";
import "forge-std/console.sol";
import "src/Upgradeable.sol";
// import "test/Nft.t.sol";

contract NftProxy is Test {
    address  actualOwner = address(0x46920);
    address minter = address(0x1920);
    address alice = address(0x700);
    
        MyNFT impl;
        ERC1967Proxy nftpr;

    function setUp() public {
        vm.startPrank(actualOwner);
        impl = new MyNFT();
        nftpr = new ERC1967Proxy(address(impl),abi.encodeWithSignature("initializeNft()"));
        vm.label(address(impl),"implementation");
        vm.label(address(nftpr),"Proxy");
        vm.label(minter ,"minter");
        vm.label(alice , "alice");
        vm.stopPrank();
    }

    function test_initializer() public {
        bytes memory data = abi.encodeWithSignature("owner()");
        (bool success, bytes memory data2) = address(nftpr).call(data);
        assertEq(actualOwner,abi.decode(data2,(address)));

    }

    function test_mint() public {
        vm.startPrank(actualOwner);
        bytes memory data = abi.encodeWithSignature("safeMint(address)",minter);
        (,bytes memory data2) = address(nftpr).call(data);
        vm.stopPrank();




    }

    function test_balance(address _addy) public {
        bytes memory data3 = abi.encodeWithSignature("balanceOf(address)",_addy);
        (,bytes memory data4) = address(nftpr).call(data3);

        assertTrue(abi.decode(data4,(uint256))>0);
    }

    function test_owner() public {
        test_mint();
        bytes memory data = abi.encodeWithSignature("ownerOf(uint256)",1);

        (,bytes memory data2) = address(nftpr).call(data);
        assertEq(abi.decode(data2,(address)),minter);
    }

    //Test transfers and approve

    function test_approve() public {
        test_mint();
        vm.startPrank(minter);
        bytes memory data = abi.encodeWithSignature("approve(address,uint256)",alice,0);
        (,bytes memory data2) = address(nftpr).call(data);
        vm.stopPrank();
    }

    function test_TransferFrom() public {

        test_approve();
        vm.startPrank(alice);
        bytes memory data = abi.encodeWithSignature("safeTransferFrom(address,address,uint256,bytes)",minter,alice,0,"");
        (bool success,bytes memory data2) = address(nftpr).call(data);
        test_balance(alice);

    }




}