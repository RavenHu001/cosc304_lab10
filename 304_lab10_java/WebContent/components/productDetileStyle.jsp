<style>
    body {
        font-family: Arial, sans-serif;
        margin: 0;
        padding: 0;
        background-color: #f9f9f9;
        color: #333;
    }

    header {
        background-color: #4CAF50;
        color: white;
        padding: 15px 20px;
        text-align: center;
        font-size: 24px;
        font-weight: bold;
    }

    .container {
        max-width: 800px;
        margin: 20px auto;
        padding: 20px;
        background-color: white;
        box-shadow: 0 2px 5px rgba(0, 0, 0, 0.1);
        border-radius: 8px;
    }

    .product-details {
        text-align: center;
        margin-bottom: 30px;
    }

    .product-details h1 {
        color: #333;
        font-size: 28px;
        margin-bottom: 10px;
    }

    .product-details p {
        font-size: 16px;
        margin: 5px 0;
    }

    .product-details strong {
        font-size: 18px;
        color: #4CAF50;
    }

    .reviews {
        margin-top: 30px;
    }

    .reviews h2 {
        font-size: 24px;
        color: #333;
        margin-bottom: 15px;
        border-bottom: 2px solid #4CAF50;
        display: inline-block;
        padding-bottom: 5px;
    }

    .review {
        border-bottom: 1px solid #ddd;
        padding: 15px 0;
    }

    .review:last-child {
        border-bottom: none;
    }

    .review p {
        margin: 5px 0;
    }

    .review-rating {
        font-weight: bold;
        color: #FFD700; /* Gold color for rating */
    }

    .add-review {
        margin-top: 30px;
    }

    .add-review h2 {
        font-size: 24px;
        color: #333;
        margin-bottom: 15px;
        border-bottom: 2px solid #4CAF50;
        display: inline-block;
        padding-bottom: 5px;
    }

    .add-review form {
        display: flex;
        flex-direction: column;
    }

    .add-review label {
        font-weight: bold;
        margin-top: 10px;
    }

    .add-review input, .add-review textarea, .add-review button {
        margin-top: 5px;
        padding: 10px;
        font-size: 16px;
        border: 1px solid #ddd;
        border-radius: 4px;
    }

    .add-review button {
        background-color: #4CAF50;
        color: white;
        cursor: pointer;
        transition: background-color 0.3s;
    }

    .add-review button:hover {
        background-color: #45A049;
    }

    .rating-stars {
        display: flex;
        gap: 5px;
    }

    .rating-stars input {
        display: none;
    }

    .rating-stars label {
        font-size: 24px;
        color: #ddd;
        cursor: pointer;
    }

    .rating-stars input:checked ~ label,
    .rating-stars input:hover ~ label {
        color: #FFD700; /* Gold */
    }

    footer {
        text-align: center;
        margin-top: 30px;
        padding: 10px;
        background-color: #f1f1f1;
        border-top: 1px solid #ddd;
    }
</style>
