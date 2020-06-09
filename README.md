# After cloning the repo
```
docker-compose exec app yarn install --check-files
```

# Create a table
```
docker-compose exec app rails generate migration CreatePost title:string content:text timestamp
```

# Execute migration
```
docker-compose exec app rails db:migrate
```

# Rollback migration
```
docker-compose exec app rails db:rollback
```

# Rails console
```
docker-compose exec app rails console
```

# Create resource from console
```
docker-compose exec app rails console
Post.create(title: "article 1",content: "contenu de l'article")
```
OR
```
docker-compose exec app rails console
mypost = Post.new(title: "article 1",content: "contenu de l'article")
mypost.save
```

# Add column
```
docker-compose exec app rails generate migration AddStatusToPost status:boolean
```

# Generate Scaffold
```
docker-compose exec app rails generate scaffold Comment name:string message:text post:belongs_to
```
