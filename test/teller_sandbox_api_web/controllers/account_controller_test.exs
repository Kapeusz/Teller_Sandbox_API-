defmodule TellerSandboxApiWeb.AccountControllerTest do
  use TellerSandboxApiWeb.ConnCase, async: true

  describe "all" do
    test "list all accounts when signed in", %{conn: conn} do
      response =
        build_conn()
        |> put_req_header("authorization", "Basic #{Base.url_encode64("test_1234567890:")}")
        |> get(Routes.account_path(conn, :all))
        |> json_response(200)

      assert response ==
      %{
        "currency" => "USD",
        "enrollment_id" => "test_MTIzNDU2Nzg5MA==",
        "id" =>  "test_acc_GEZDGNBVGY3TQOJQ",
        "institution" => %{
          "id" => "chase", "name" => "Chase"
        },
        "last_four" =>  "7890",
        "links" => %{
          "balances" => "http://localhost:4000/accounts/test_acc_GEZDGNBVGY3TQOJQ/balances",
          "details" => "http://localhost:4000/accounts/test_acc_GEZDGNBVGY3TQOJQ/details",
          "self" =>  "http://localhost:4000/accounts/test_acc_GEZDGNBVGY3TQOJQ",
          "transactions" =>  "http://localhost:4000/accounts/test_acc_GEZDGNBVGY3TQOJQ/transactions"
        },
        "name" =>  "George W. Bush",
        "subtype" => "checking",
        "type" => "depository"
      }
    end

    test "list multiple accounts", %{conn: conn} do
      response =
        build_conn()
        |> put_req_header("authorization", "Basic #{Base.url_encode64("test_multiple_1234567891:")}")
        |> get(Routes.account_path(conn, :all))
        |> json_response(200)

      assert response ==
        [
          %{
            "currency" => "USD",
            "enrollment_id" => "test_NzcyMjg0MjM1",
            "id" => "test_acc_G43TEMRYGQZDGNI=",
            "institution" =>
            %{
              "id" => "capital_one",
              "name" => "Capital One"
            },
            "last_four" => "4235",
            "links"=>
            %{
              "balances" => "http://localhost:4000/accounts/test_acc_G43TEMRYGQZDGNI=/balances",
              "details" => "http://localhost:4000/accounts/test_acc_G43TEMRYGQZDGNI=/details",
              "self" => "http://localhost:4000/accounts/test_acc_G43TEMRYGQZDGNI=",
              "transactions" => "http://localhost:4000/accounts/test_acc_G43TEMRYGQZDGNI=/transactions"
            },
            "name" => "Ronald Reagan",
            "subtype" => "checking",
            "type" => "depository"
          },
          %{
            "currency" => "USD",
            "enrollment_id" => "test_MzQ0NDMyMjk3Nw==",
            "id" => "test_acc_GM2DINBTGIZDSNZX",
            "institution" =>
            %{
              "id" => "wells_fargo",
              "name" => "Wells Fargo"
            },
            "last_four" => "2977",
            "links" =>
            %{
              "balances" => "http://localhost:4000/accounts/test_acc_GM2DINBTGIZDSNZX/balances",
              "details" => "http://localhost:4000/accounts/test_acc_GM2DINBTGIZDSNZX/details",
              "self" => "http://localhost:4000/accounts/test_acc_GM2DINBTGIZDSNZX",
              "transactions" => "http://localhost:4000/accounts/test_acc_GM2DINBTGIZDSNZX/transactions"
            },
            "name" => "Jimmy Carter",
            "subtype" => "checking",
            "type" => "depository"
          },
          %{
            "currency" => "USD",
            "enrollment_id" => "test_Mjg2Mzc0Njk0Mw==",
            "id" => "test_acc_GI4DMMZXGQ3DSNBT",
            "institution" =>
            %{
              "id" => "bank_of_america",
              "name" => "Bank of America"
            },
            "last_four" => "6943",
            "links" =>
            %{
              "balances" => "http://localhost:4000/accounts/test_acc_GI4DMMZXGQ3DSNBT/balances",
              "details" => "http://localhost:4000/accounts/test_acc_GI4DMMZXGQ3DSNBT/details",
              "self" => "http://localhost:4000/accounts/test_acc_GI4DMMZXGQ3DSNBT",
              "transactions" => "http://localhost:4000/accounts/test_acc_GI4DMMZXGQ3DSNBT/transactions"
            },
            "name" => "Bill Clinton",
            "subtype" => "checking",
            "type" => "depository"
          },
          %{
            "currency" => "USD",
            "enrollment_id" => "test_MTIzNDU2Nzg5MQ==",
            "id" => "test_acc_GEZDGNBVGY3TQOJR",
            "institution" =>
            %{
              "id" => "citibank",
              "name" => "Citibank"
            },
            "last_four" => "7891",
            "links" =>
            %{
              "balances" => "http://localhost:4000/accounts/test_acc_GEZDGNBVGY3TQOJR/balances",
              "details" => "http://localhost:4000/accounts/test_acc_GEZDGNBVGY3TQOJR/details",
              "self" => "http://localhost:4000/accounts/test_acc_GEZDGNBVGY3TQOJR",
              "transactions" => "http://localhost:4000/accounts/test_acc_GEZDGNBVGY3TQOJR/transactions"
            },
              "name" => "Donald Trump",
              "subtype" => "checking",
              "type" => "depository"
          }
        ]
    end
  end

  describe "get" do
    test "id does not exist - return 404", %{conn: conn} do
      response =
        build_conn()
        |> put_req_header("authorization", "Basic #{Base.url_encode64("test_2:")}")
        |> get(Routes.account_path(conn, :get, "not an id"), %{"account_id" => "not an id"})

        assert response.status == 404
        assert response.resp_body == "Not Found"
    end

    test "id exist - return account", %{conn: conn} do
      response =
        build_conn()
        |> put_req_header("authorization", "Basic #{Base.url_encode64("test_1234567890:")}")
        |> get(Routes.account_path(conn, :all))
        |> json_response(200)

        assert response == %{
          "currency" => "USD",
          "enrollment_id" => "test_MTIzNDU2Nzg5MA==",
          "id" =>  "test_acc_GEZDGNBVGY3TQOJQ",
          "institution" => %{
            "id" => "chase", "name" => "Chase"
          },
          "last_four" =>  "7890",
          "links" =>
          %{
            "balances" => "http://localhost:4000/accounts/test_acc_GEZDGNBVGY3TQOJQ/balances",
            "details" => "http://localhost:4000/accounts/test_acc_GEZDGNBVGY3TQOJQ/details",
            "self" =>  "http://localhost:4000/accounts/test_acc_GEZDGNBVGY3TQOJQ",
            "transactions" =>  "http://localhost:4000/accounts/test_acc_GEZDGNBVGY3TQOJQ/transactions"
          },
          "name" =>  "George W. Bush",
          "subtype" => "checking",
          "type" => "depository"
        }
    end
  end

  describe "get_details" do
    test "which exists", %{conn: conn} do
      response =
        build_conn()
        |> put_req_header("authorization", "Basic #{Base.url_encode64("test_1234567890:")}")
        |> get(Routes.account_path(conn, :get_details, "test_acc_GEZDGNBVGY3TQOJQ"), %{
          "account_id" => "test_acc_GEZDGNBVGY3TQOJQ"
        })
        |> json_response(200)

      assert response ==
        %{
          "account_id" => "test_acc_GEZDGNBVGY3TQOJQ",
          "account_number" => "1234567890",
          "links"  =>
          %{
            "account" => "http://localhost:4000/accounts/test_acc_GEZDGNBVGY3TQOJQ",
            "self" => "http://localhost:4000/accounts/test_acc_GEZDGNBVGY3TQOJQ/details"
          },
          "routing_numbers" =>
          %{
             "ach" => 3252069733
          }
        }
    end

    test "which do not exist", %{conn: conn} do
      response =
        build_conn()
        |> put_req_header("authorization", "Basic #{Base.url_encode64("test_1:")}")
        |> get(Routes.account_path(conn, :get_details, "not_id"), %{
          "account_id" => "test_acc_GEZDGNBVGY3TQOJQ"
        })

      assert response.status == 404
      assert response.resp_body == "Not Found"
    end
  end

  describe "get_balance" do
    test "for account which exists", %{conn: conn} do
      response =
        build_conn()
        |> put_req_header("authorization", "Basic #{Base.url_encode64("test_1234567890:")}")
        |> get(Routes.account_path(conn, :get_balances, "test_acc_GEZDGNBVGY3TQOJQ"), %{
          "account_id" => "test_acc_GEZDGNBVGY3TQOJQ"
        })
        |> json_response(200)

      assert response ==
        %{
          "account_id" => "test_acc_GEZDGNBVGY3TQOJQ",
          "ledger" => "33648.09",
          "available" => "33803.48",
          "links"  =>
          %{
            "self" => "http://localhost:4000/accounts/test_acc_GEZDGNBVGY3TQOJQ/balances",
            "account" => "http://localhost:4000/accounts/test_acc_GEZDGNBVGY3TQOJQ",
          }
        }
    end

    test "which do not exist", %{conn: conn} do
      response =
        build_conn()
        |> put_req_header("authorization", "Basic #{Base.url_encode64("test_1:")}")
        |> get(Routes.account_path(conn, :get_balances, "not_id"), %{
          "account_id" => "test_acc_GEZDGNBVGY3TQOJQ"
        })

      assert response.status == 404
      assert response.resp_body == "Not Found"
    end
  end
end
